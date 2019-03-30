defmodule Akedia.Factory do
  use ExMachina.Ecto, repo: Akedia.Repo

  def credential_factory do
    %Akedia.Accounts.Credential{
      email: sequence(:email, &"email-#{&1}@inhji.de"),
      encrypted_password: sequence(:encrypted_password, &"awesome-password-#{&1}")
    }
  end

  def user_factory do
    %Akedia.Accounts.User{
      name: sequence(:name, &"MyRealName#{&1}"),
      username: sequence(:username, &"my-username-#{&1}"),
      credential: build(:credential)
    }
  end
end
