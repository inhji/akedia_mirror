defmodule Akedia.ListensTest do
  use Akedia.DataCase

  alias Akedia.Listens

  describe "artists" do
    alias Akedia.Listens.Artist

    @valid_attrs %{mbid: "some mbid", name: "some name"}
    @update_attrs %{mbid: "some updated mbid", name: "some updated name"}
    @invalid_attrs %{mbid: nil, name: nil}

    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Listens.create_artist()

      artist
    end

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Listens.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Listens.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Listens.create_artist(@valid_attrs)
      assert artist.mbid == "some mbid"
      assert artist.name == "some name"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listens.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{} = artist} = Listens.update_artist(artist, @update_attrs)
      assert artist.mbid == "some updated mbid"
      assert artist.name == "some updated name"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Listens.update_artist(artist, @invalid_attrs)
      assert artist == Listens.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Listens.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Listens.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Listens.change_artist(artist)
    end
  end

  describe "albums" do
    alias Akedia.Listens.Album

    @valid_attrs %{mbid: "some mbid", name: "some name"}
    @update_attrs %{mbid: "some updated mbid", name: "some updated name"}
    @invalid_attrs %{mbid: nil, name: nil}

    def album_fixture(attrs \\ %{}) do
      {:ok, album} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Listens.create_album()

      album
    end

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Listens.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Listens.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Listens.create_album(@valid_attrs)
      assert album.mbid == "some mbid"
      assert album.name == "some name"
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listens.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      assert {:ok, %Album{} = album} = Listens.update_album(album, @update_attrs)
      assert album.mbid == "some updated mbid"
      assert album.name == "some updated name"
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Listens.update_album(album, @invalid_attrs)
      assert album == Listens.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Listens.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Listens.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Listens.change_album(album)
    end
  end
end
