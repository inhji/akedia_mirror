defmodule Akedia.Accounts do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Accounts.{User, Credential}

  def count_users do
    Repo.aggregate(from(u in User), :count, :id)
  end

  def get_user!() do
    User
    |> Repo.one!()
    |> Repo.preload(:credential)
  end
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credential)
  end
  def has_user?() do
    count_users() > 0
  end

  def get_user_by_email(email) do
    query = from c in Credential,
            join: u in User,
            where: c.email == ^email,
            select: u

    Repo.one(query)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)
  def get_credential_by_user(id) do
    query = from c in Credential,
            where: c.user_id == ^id

    Repo.one!(query)
  end

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential, attrs \\ %{}) do
    Credential.changeset(credential, attrs)
  end
end
