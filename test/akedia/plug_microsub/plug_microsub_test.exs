defmodule Akedia.PlugMicrosub.PlugMicrosubTest do
  use Akedia.DataCase
  alias Akedia.Plugs.PlugMicrosub

  describe "maybe_wrap_entry_ids/1" do
    test "maybe_wrap_entry_ids/1 returns a list if entry_ids is a list" do
      assert PlugMicrosub.maybe_wrap_entry_ids([1, 2, 3]) == [1, 2, 3]
      assert PlugMicrosub.maybe_wrap_entry_ids(["1", "2", "3"]) == ["1", "2", "3"]
    end

    test "maybe_wrap_entry_ids/1 returns values as list if entry_ids is a map" do
      map1 = %{"0" => 1, "1" => 2, "2" => 3}
      map2 = %{"0" => "1", "1" => "2", "2" => "3"}

      assert PlugMicrosub.maybe_wrap_entry_ids(map1) == [1, 2, 3]
      assert PlugMicrosub.maybe_wrap_entry_ids(map2) == ["1", "2", "3"]
    end

    test "maybe_wrap_entry_ids/1 wraps a single value in a list" do
      assert PlugMicrosub.maybe_wrap_entry_ids(1) == [1]
      assert PlugMicrosub.maybe_wrap_entry_ids("1") == ["1"]
    end
  end

  describe "validate_paging/1" do
    test "validate_paging/1 returns :ok when neither before nor after are supplied" do
      params1 = %{
        :query_params => %{},
        :body_params => %{}
      }

      assert PlugMicrosub.validate_paging(params1) == {:ok, nil, nil}
    end

    test "validate_paging/1 returns :ok when before or after are supplied in query_params" do
      params1 = %{
        :query_params => %{"before" => "123"},
        :body_params => %{}
      }

      params2 = %{
        :query_params => %{"after" => "456"},
        :body_params => %{}
      }

      assert PlugMicrosub.validate_paging(params1) == {:ok, 123, nil}
      assert PlugMicrosub.validate_paging(params2) == {:ok, nil, 456}
    end

    test "validate_paging/1 returns :ok when before or after are supplied in body_params" do
      params1 = %{
        :query_params => %{},
        :body_params => %{"before" => "123"}
      }

      params2 = %{
        :query_params => %{},
        :body_params => %{"after" => "456"}
      }

      assert PlugMicrosub.validate_paging(params1) == {:ok, 123, nil}
      assert PlugMicrosub.validate_paging(params2) == {:ok, nil, 456}
    end

    test "validate_paging/1 returns :error when before and after are supplied in query_params" do
      params1 = %{
        :query_params => %{"before" => "123", "after" => "456"},
        :body_params => %{}
      }

      assert PlugMicrosub.validate_paging(params1) == {:error, "Bad Paging information"}
    end

    test "validate_paging/1 returns :error when before and after are supplied in body_params" do
      params1 = %{
        :query_params => %{},
        :body_params => %{"before" => "123", "after" => "456"}
      }

      assert PlugMicrosub.validate_paging(params1) == {:error, "Bad Paging information"}
    end
  end
end
