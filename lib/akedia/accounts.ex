defmodule Akedia.Accounts do
  @moduledoc """
  Account context, contains the following Models:

  * `Akedia.Accounts.User`
  * `Akedia.Accounts.Credential`
  * `Akedia.Accounts.Profile`
  """

  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Accounts.{User, Credential, Profile}

  @user_preloads [:credential, :profiles]

  # $$\   $$\                               
  # $$ |  $$ |                              
  # $$ |  $$ | $$$$$$$\  $$$$$$\   $$$$$$\  
  # $$ |  $$ |$$  _____|$$  __$$\ $$  __$$\ 
  # $$ |  $$ |\$$$$$$\  $$$$$$$$ |$$ |  \__|
  # $$ |  $$ | \____$$\ $$   ____|$$ |      
  # \$$$$$$  |$$$$$$$  |\$$$$$$$\ $$ |      
  #  \______/ \_______/  \_______|\__|      

  @doc model: :user
  def count_users, do: Repo.aggregate(from(u in User), :count, :id)

  @doc model: :user
  def get_user!() do
    User
    |> Repo.one!()
    |> Repo.preload(@user_preloads)
  end

  @doc model: :user
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(@user_preloads)
  end

  @doc model: :user
  def get_user(id) do
    User
    |> Repo.get(id)
    |> Repo.preload(@user_preloads)
  end

  @doc """
  Checks if any user exist.
  """
  @doc model: :user
  def user_exists?(), do: count_users() > 0

  @doc """
  Checks if the user with `username` exists.
  """
  @doc model: :user
  def user_exists?(username) do
    case get_user!() do
      nil -> false
      user -> user.username == username
    end
  end

  @doc model: :user
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

  @doc model: :user
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :user
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :user
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc model: :user
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  #  $$$$$$\                            $$\                      $$\     $$\           $$\ 
  # $$  __$$\                           $$ |                     $$ |    \__|          $$ |
  # $$ /  \__| $$$$$$\   $$$$$$\   $$$$$$$ | $$$$$$\  $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$ |
  # $$ |      $$  __$$\ $$  __$$\ $$  __$$ |$$  __$$\ $$  __$$\\_$$  _|  $$ | \____$$\ $$ |
  # $$ |      $$ |  \__|$$$$$$$$ |$$ /  $$ |$$$$$$$$ |$$ |  $$ | $$ |    $$ | $$$$$$$ |$$ |
  # $$ |  $$\ $$ |      $$   ____|$$ |  $$ |$$   ____|$$ |  $$ | $$ |$$\ $$ |$$  __$$ |$$ |
  # \$$$$$$  |$$ |      \$$$$$$$\ \$$$$$$$ |\$$$$$$$\ $$ |  $$ | \$$$$  |$$ |\$$$$$$$ |$$ |
  #  \______/ \__|       \_______| \_______| \_______|\__|  \__|  \____/ \__| \_______|\__|

  @doc model: :credential
  def list_credentials do
    Repo.all(Credential)
  end

  @doc model: :credential
  def get_credential!(id), do: Repo.get!(Credential, id)

  @doc model: :credential
  def get_credential_by_user(id) do
    query =
      from c in Credential,
        where: c.user_id == ^id

    Repo.one!(query)
  end

  @doc model: :credential
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :credential
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :credential
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc model: :credential
  def change_credential(%Credential{} = credential, attrs \\ %{}) do
    Credential.changeset(credential, attrs)
  end

  # $$$$$$$\                       $$$$$$\  $$\ $$\           
  # $$  __$$\                     $$  __$$\ \__|$$ |          
  # $$ |  $$ | $$$$$$\   $$$$$$\  $$ /  \__|$$\ $$ | $$$$$$\  
  # $$$$$$$  |$$  __$$\ $$  __$$\ $$$$\     $$ |$$ |$$  __$$\ 
  # $$  ____/ $$ |  \__|$$ /  $$ |$$  _|    $$ |$$ |$$$$$$$$ |
  # $$ |      $$ |      $$ |  $$ |$$ |      $$ |$$ |$$   ____|
  # $$ |      $$ |      \$$$$$$  |$$ |      $$ |$$ |\$$$$$$$\ 
  # \__|      \__|       \______/ \__|      \__|\__| \_______|                                                    

  @doc model: :profile
  def list_profiles do
    Profile
    |> order_by(desc: :public, desc: :rel_value, desc: :username)
    |> Repo.all()
  end

  @doc model: :profile
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc model: :profile
  def get_profile_by_rel_value(rel_value) do
    Profile
    |> Repo.get_by!(rel_value: rel_value)
  end

  @doc model: :profile
  def create_profile(attrs \\ %{}) do
    user = get_user!()

    user
    |> Ecto.build_assoc(:profiles)
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :profile
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :profile
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc model: :profile
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
