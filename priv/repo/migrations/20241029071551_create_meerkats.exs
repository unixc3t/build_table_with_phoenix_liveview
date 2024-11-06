defmodule Mhm.Repo.Migrations.CreateMeerkats do
  use Ecto.Migration

  def change do
    create table(:meerkats) do
      add(:name, :string)

      timestamps()
    end

    create index(:meerkats, :name)
  end
end
