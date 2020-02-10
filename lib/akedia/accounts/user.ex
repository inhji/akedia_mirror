defmodule Akedia.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.{Credential, Profile}
  alias AkediaWeb.Router.Helpers, as: Routes

  schema "users" do
    field :name, :string
    field :username, :string

    field :tagline, :string, default: ""
    field :about, :string, default: ""
    field :now, :string, default: ""

    field :avatar, Akedia.Media.AvatarUploader.Type
    field :cover, Akedia.Media.CoverUploader.Type

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

  def actor_url(), do: Routes.user_url(AkediaWeb.Endpoint, :show)
  def inbox_url(), do: Routes.inbox_url(AkediaWeb.Endpoint, :index)
  def outbox_url(), do: Routes.outbox_url(AkediaWeb.Endpoint, :index)
  def pubkey_url(), do: actor_url() <> "#main-key"

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
