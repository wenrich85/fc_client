defmodule FcClient.OrganizationTest do
  use FcClient.DataCase

  alias FcClient.Organization

  describe "positions" do
    alias FcClient.Organization.Position

    import FcClient.OrganizationFixtures

    @invalid_attrs %{parent: nil, description: nil, title: nil}

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Organization.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Organization.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      valid_attrs = %{parent: 42, description: "some description", title: "some title"}

      assert {:ok, %Position{} = position} = Organization.create_position(valid_attrs)
      assert position.parent == 42
      assert position.description == "some description"
      assert position.title == "some title"
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organization.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()
      update_attrs = %{parent: 43, description: "some updated description", title: "some updated title"}

      assert {:ok, %Position{} = position} = Organization.update_position(position, update_attrs)
      assert position.parent == 43
      assert position.description == "some updated description"
      assert position.title == "some updated title"
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Organization.update_position(position, @invalid_attrs)
      assert position == Organization.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Organization.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Organization.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Organization.change_position(position)
    end
  end
end
