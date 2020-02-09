defmodule Akedia.Accounts do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Accounts.{User, Credential, Profile}

  @user_preloads [:credential, :profiles]

  def count_users do
    Repo.aggregate(from(u in User), :count, :id)
  end

  def get_user!() do
    User
    |> Repo.one!()
    |> Repo.preload(@user_preloads)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(@user_preloads)
  end

  def get_user(id) do
    User
    |> Repo.get(id)
    |> Repo.preload(@user_preloads)
  end

  def has_user?() do
    count_users() > 0
  end

  @doc """
  Checks if the user with `username` exists.
  """
  def user_exists?(username) do
    case get_user!() do
      nil -> false
      user -> user.username == username
    end
  end

  def get_user_by_email(email) do
    query =
      from c in Credential,
        join: u in User,
        where: c.email == ^email,
        select: u

    query
    |> Repo.one()
    |> Repo.preload(@user_preloads)
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
    query =
      from c in Credential,
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

  def list_profiles do
    Profile
    |> order_by(desc: :public, desc: :rel_value, desc: :username)
    |> Repo.all()
  end

  def get_profile!(id), do: Repo.get!(Profile, id)

  def get_profile_by_rel_value(rel_value) do
    Profile
    |> Repo.get_by!(rel_value: rel_value)
  end

  def create_profile(attrs \\ %{}) do
    user = get_user!()

    user
    |> Ecto.build_assoc(:profiles)
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
