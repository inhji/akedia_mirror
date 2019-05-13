defmodule Akedia.IndieTest do
  use Akedia.DataCase

  alias Akedia.Indie

  describe "syndications" do
    alias Akedia.Indie.Syndication

    @valid_attrs %{type: "some type", url: "some url"}
    @update_attrs %{type: "some updated type", url: "some updated url"}
    @invalid_attrs %{type: nil, url: nil}

    def syndication_fixture(attrs \\ %{}) do
      {:ok, syndication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Indie.create_syndication()

      syndication
    end

    test "list_syndications/0 returns all syndications" do
      syndication = syndication_fixture()
      assert Indie.list_syndications() == [syndication]
    end

    test "get_syndication!/1 returns the syndication with given id" do
      syndication = syndication_fixture()
      assert Indie.get_syndication!(syndication.id) == syndication
    end

    test "create_syndication/1 with valid data creates a syndication" do
      assert {:ok, %Syndication{} = syndication} = Indie.create_syndication(@valid_attrs)
      assert syndication.type == "some type"
      assert syndication.url == "some url"
    end

    test "create_syndication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Indie.create_syndication(@invalid_attrs)
    end

    test "update_syndication/2 with valid data updates the syndication" do
      syndication = syndication_fixture()
      assert {:ok, %Syndication{} = syndication} = Indie.update_syndication(syndication, @update_attrs)
      assert syndication.type == "some updated type"
      assert syndication.url == "some updated url"
    end

    test "update_syndication/2 with invalid data returns error changeset" do
      syndication = syndication_fixture()
      assert {:error, %Ecto.Changeset{}} = Indie.update_syndication(syndication, @invalid_attrs)
      assert syndication == Indie.get_syndication!(syndication.id)
    end

    test "delete_syndication/1 deletes the syndication" do
      syndication = syndication_fixture()
      assert {:ok, %Syndication{}} = Indie.delete_syndication(syndication)
      assert_raise Ecto.NoResultsError, fn -> Indie.get_syndication!(syndication.id) end
    end

    test "change_syndication/1 returns a syndication changeset" do
      syndication = syndication_fixture()
      assert %Ecto.Changeset{} = Indie.change_syndication(syndication)
    end
  end
end
