defmodule Akedia.UserTest do
	use Akedia.DataCase
	import Akedia.Factory

	alias Akedia.Accounts
	alias Akedia.Accounts.User

	@update_attrs %{name: "some updated name", username: "some updated username"}
	@invalid_attrs %{name: nil, username: nil}

	describe "users" do
		test "get_user!/0 returns the first user" do
			user = insert(:user)
			assert Accounts.get_user!() == user
		end

		test "get_user/1 returns the user with given id" do  
			user = insert(:user) 
			assert Accounts.get_user(user.id) == user
		end

		test "get_user!/1 returns the user with given id" do  
			user = insert(:user) 
			assert Accounts.get_user!(user.id) == user
		end

		test "update_user/2 with valid data updates the user" do
			user = insert(:user)
			assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
			assert user.name == "some updated name"
			assert user.username == "some updated username"
		end

		test "update_user/2 with invalid data returns error changeset" do
			user = insert(:user)
			assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
			assert user == Accounts.get_user!(user.id)
		end

		test "change_user/1 returns a user changeset" do
			user = insert(:user)
			assert %Ecto.Changeset{} = Accounts.change_user(user)
		end

		test "count_users/0 counts users" do
			assert Accounts.count_users == 0
		end

		test "has_user?/0 checks if any user exists" do
			assert Accounts.has_user?() == false
		end

		test "get_user_by_email/1 gets a user by email" do
			user = insert(:user)
			assert Accounts.get_user_by_email(user.credential.email) == user
		end
	end
end
