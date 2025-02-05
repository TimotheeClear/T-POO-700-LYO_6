defmodule TimeManagerApi.Repo.Migrations.CreateTeamToUsers do
  use Ecto.Migration

  def change do
    create table(:team_to_users) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create index(:team_to_users, [:user_id])
    create index(:team_to_users, [:team_id])
    create unique_index(:team_to_users, [:user_id, :team_id], name: :one_user_by_team)
  end
end
