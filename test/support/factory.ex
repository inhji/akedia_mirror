defmodule Akedia.Factory do
  use ExMachina.Ecto, repo: Akedia.Repo
  alias Akedia.Accounts.{Credential, User, Profile}
  alias Akedia.Content.{Story, Entity, Page, Bookmark}
  alias Akedia.Media.Favicon

  def credential_factory do
    %Credential{
      email: sequence(:email, &"email-#{&1}@inhji.de"),
      encrypted_password: sequence(:encrypted_password, &"awesome-password-#{&1}")
    }
  end

  def profile_factory do
    %Profile{
      name: sequence(:name, &"profile-#{&1}"),
      url: sequence(:url, &"http://#{&1}.inhji.de")
    }
  end

  def user_factory do
    %User{
      name: sequence(:name, &"MyRealName#{&1}"),
      username: sequence(:username, &"my-username-#{&1}"),
      credential: build(:credential),
      profiles: build_list(3, :profile)
    }
  end
end
