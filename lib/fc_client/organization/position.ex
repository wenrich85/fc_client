defmodule FcClient.Organization.Position do
  use Ecto.Schema
  import Ecto.Changeset

  schema "positions" do
    field :parent, :integer
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:title, :description, :parent])
    |> validate_required([:title, :description, :parent])
  end
end
