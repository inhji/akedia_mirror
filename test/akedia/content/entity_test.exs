defmodule Akedia.ContentTest do
  use Akedia.DataCase

  alias Akedia.Content

  describe "entities" do
    alias Akedia.Content.Entity

    @valid_attrs %{is_pinned: true, is_published: true}
    @update_attrs %{is_pinned: false, is_published: false}
    @invalid_attrs %{is_pinned: nil, is_published: nil}

    def entity_fixture(attrs \\ %{}) do
      {:ok, entity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_entity()

      entity
    end

    test "list_entities/0 returns all entities" do
      entity = entity_fixture()
      assert Content.list_entities() == [entity]
    end

    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Content.get_entity!(entity.id) == entity
    end

    test "create_entity/1 with valid data creates a entity" do
      assert {:ok, %Entity{} = entity} = Content.create_entity(@valid_attrs)
      assert entity.is_pinned == true
      assert entity.is_published == true
    end

    test "create_entity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_entity(@invalid_attrs)
    end

    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{} = entity} = Content.update_entity(entity, @update_attrs)
      assert entity.is_pinned == false
      assert entity.is_published == false
    end

    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_entity(entity, @invalid_attrs)
      assert entity == Content.get_entity!(entity.id)
    end

    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Content.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Content.get_entity!(entity.id) end
    end

    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Content.change_entity(entity)
    end
  end
end
