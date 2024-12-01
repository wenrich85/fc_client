defmodule FcClient.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :title, :string
      add :description, :string
      add :parent, :integer

      timestamps()
    end
  end
end
