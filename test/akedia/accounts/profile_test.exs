defmodule Akedia.ProfileTest do
  use Akedia.DataCase
  import Akedia.Factory

  alias Akedia.Accounts

  describe "profiles" do
    test "list_profiles/0 lists all profiles" do
      profiles = insert_list(3, :profile)
      assert profiles == Accounts.list_profiles()
    end

    test "get_profile!/1 returns a profile by id" do
      profile = insert(:profile)
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "get_profile_by_rel_value/1 returns a profile by rel-value" do
      profile = insert(:profile)
      assert profile == Accounts.get_profile_by_rel_value("me")

      profile2 = insert(:profile, %{rel_value: "microsub"})
      assert profile2 == Accounts.get_profile_by_rel_value("microsub")
    end
  end
end
