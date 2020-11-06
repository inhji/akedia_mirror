defmodule Akedia.Accounts.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.{Credential, Profile}
  alias AkediaWeb.Router.Helpers, as: Routes

  schema "users" do
    field :name, :string
    field :username, :string

    field :tagline, :string, default: ""
    field :about, :string, default: ""
    field :now, :string, default: ""

    field :avatar, Akedia.Accounts.AvatarUploader.Type
    field :cover, Akedia.Accounts.CoverUploader.Type

    field :priv_key, :string
    field :pub_key, :string

    has_one(:credential, Credential)
    has_many(:profiles, Profile)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :now, :about, :tagline, :priv_key, :pub_key])
    |> cast_attachments(attrs, [:avatar, :cover])
    |> maybe_generate_pub_key_pair()
    |> validate_required([:name, :username, :priv_key, :pub_key])
    |> unique_constraint(:username)
  end

  @doc """
  Returns the actor url
  """
  def actor_url(), do: Routes.user_url(AkediaWeb.Endpoint, :show)

  @doc """
  Returns the inbox url
  """
  def inbox_url(), do: Routes.inbox_url(AkediaWeb.Endpoint, :index)

  @doc """
  Returns the outbox url
  """
  def outbox_url(), do: Routes.outbox_url(AkediaWeb.Endpoint, :index)

  @doc """
  Returns the public key url
  """
  def pubkey_url(), do: actor_url() <> "#main-key"

  @doc """
  Returns the user as an activity pub actor. Context needs to be added via `Akedia.Helpers.with_context/1` or `Akedia.Helpers.with_context/2`

  ## Examples

  ```
  {
    "icon": {
      "mediaType": "image/png",
      "type": "Image",
      "url": "http://localhost:4000/uploads/user/me_thumb.png?v=63746169254"
    },
    "id": "http://localhost:4000/about",
    "name": "Inhji",
    "preferredUsername": "inhji",
    "publicKey": {
      "id": "http://localhost:4000/about#main-key",
      "owner": "http://localhost:4000/about",
      "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA29XxA2UamqFZFuX9zwpU\neVC+zFRgSkDeTVAjdKbddDbTi0nXVbxQepVsvjG86jdj7v9XKNm3PfB54zJWGJ/8\nQ/rTK19TXwGsGrBBGvSl4asIn8erQQkWDhlzyghOpNznquunbXvt0KQRkcaXg6r2\nsQluKCTmV3NV+RpynlZd+OSZDyqBKmnzKbFAk5R1F05hyoANy9ogp6Ogae0vGkGJ\nOseOaam6HuXD1oOvd262BjfKVH0L9Y4wsb9yao7kAKNSTauyvfTkIuy9dv1qh1cj\ns+a41L+SnLMGMtMa/tERhl4sYglHzPAUrn2rSTpEM9+yMvsbph/khRkU3aMN36ov\nfQIDAQAB\n-----END PUBLIC KEY-----\n"
    },
    "summary": "*daydreamer*. \r\ntinkerer. depressionist. overthinker. rebel without a voice. bruhgrammer. catlover. slightly human.",
    "type": "Person"
  }
  ```

  """
  def to_json(%Akedia.Accounts.User{} = user) do
    %{
      "id" => actor_url(),
      "type" => "Person",
      "preferredUsername" => user.username,
      "name" => user.name,
      "summary" => user.tagline,
      "inbox" => inbox_url(),
      "outbox" => outbox_url(),
      # "followers" => follower_url(),
      # "following" => following_url(),
      "publicKey" => %{
        "id" => pubkey_url(),
        "owner" => actor_url(),
        "publicKeyPem" => user.pub_key
      },
      "icon" => %{
        "mediaType" => MIME.type("png"),
        "url" => Akedia.url(AkediaWeb.Helpers.Media.avatar_url(user)),
        "type" => "Image"
      }
    }
  end

  @doc false
  defp maybe_generate_pub_key_pair(changeset) do
    case get_field(changeset, :priv_key) do
      nil ->
        {:ok, {priv, pub}} = RsaEx.generate_keypair()

        changeset
        |> put_change(:priv_key, priv)
        |> put_change(:pub_key, pub)

      _ ->
        changeset
    end
  end
end
