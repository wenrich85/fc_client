defmodule FcClient.OrganizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FcClient.Organization` context.
  """

  @doc """
  Generate a position.
  """
  def position_fixture(attrs \\ %{}) do
    {:ok, position} =
      attrs
      |> Enum.into(%{
        parent: 42,
        description: "some description",
        title: "some title"
      })
      |> FcClient.Organization.create_position()

    position
  end
end
