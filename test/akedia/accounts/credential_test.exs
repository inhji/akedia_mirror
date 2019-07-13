defmodule Akedia.CredentialTest do
	use Akedia.DataCase
	import Akedia.Factory

	alias Akedia.Accounts
	alias Akedia.Accounts.Credential

	@update_attrs %{
		email: "some updated email",
		encrypted_password: "some updated encrypted_password"
	}
	@invalid_attrs %{email: nil, encrypted_password: nil}

	describe "credentials" do
		test "get_credential!/1 returns the credential with given id" do
			credential = insert(:credential)
			assert Accounts.get_credential!(credential.id) == credential
		end

		test "update_credential/2 with valid data updates the credential" do
			user = insert(:user)

			assert {:ok, %Credential{} = credential} =
							 Accounts.update_credential(user.credential, @update_attrs)

			assert credential.email == "some updated email"
			assert Bcrypt.verify_pass("some updated encrypted_password", credential.encrypted_password)
		end

		test "update_credential/2 with invalid data returns error changeset" do
			credential = insert(:credential)
			assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
			assert credential == Accounts.get_credential!(credential.id)
		end

		test "change_credential/1 returns a credential changeset" do
			credential = insert(:credential)
			assert %Ecto.Changeset{} = Accounts.change_credential(credential)
		end
	end
end
