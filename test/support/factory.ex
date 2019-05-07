defmodule Akedia.Factory do
  use ExMachina.Ecto, repo: Akedia.Repo
  alias Akedia.Accounts.{Credential, User, Profile}
  alias Akedia.Content.{Story, Entity, Topic, Page, Bookmark}
  alias Akedia.Media.{Image, Favicon}

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


  def entity_factory do
    %Entity{
      images: [],
      topics: []
    }
  end

  def story_factory do
    %Story{
      title: sequence(:title, &"Story-#{&1}"),
      content: sequence(:content, &"Content-#{&1}"),
      entity: build(:entity),
      slug: sequence(:slug, &"story-#{&1}")
    }
  end

  def page_factory do
    %Page{
      title: sequence(:title, &"Page-#{&1}"),
      content: sequence(:content, &"Content-#{&1}"),
      entity: build(:entity),
      slug: sequence(:slug, &"page-#{&1}")
    }
  end

  def bookmark_factory do
    %Bookmark{
      title: sequence(:title, &"Bookmark-#{&1}"),
      content: sequence(:content, &"Content-#{&1}"),
      url: sequence(:url, &"http://#{&1}.inhji.de"),
      slug: sequence(:slug, &"bookmark-#{&1}"),
      entity: build(:entity),
      favicon: nil
    }
  end

  def favicon_factory do
    %Favicon {
      name: sequence(:name, &"https://#{&1}.foobar.com/favicon.ico"),
      hostname: sequence(:hostname, &"#{&1}.foobar.com")
    }
  end

  # TODO: name needs to be %Plug.Upload at some point
  # def image_factory do
  #   %Image{
  #     name: sequence(:name, &"image-#{&1}"),
  #     text: sequence(:text, &"imagetext-#{&1}"),
  #     path: sequence(:path, &"imagepath-#{&1}")
  #   }
  # end

  # TODO: This fails for some reason, somehow related to timestamps, see:
  # https://github.com/thoughtbot/ex_machina/issues/269
  # def topic_factory do
  #   %Topic{
  #     text: sequence(:text, &"topic-#{&1}")
  #   }
  # end
end
