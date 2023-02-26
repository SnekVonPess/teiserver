defmodule Central.Repo.Migrations.AddLobbyPolicies do
  use Ecto.Migration

  def change do
    create table(:lobby_policies) do
      add :name, :string

      add :icon, :string
      add :colour, :string

      add :map_list, {:array, :string}
      add :agent_name_list, {:array, :string}

      add :min_rating, :integer
      add :max_rating, :integer

      add :min_uncertainty, :integer
      add :max_uncertainty, :integer

      add :min_rank, :integer
      add :max_rank, :integer

      add :min_teamsize, :integer
      add :max_teamsize, :integer

      timestamps()
    end
  end
end
