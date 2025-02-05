defmodule TimeManagerApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:email, :string)
      add(:password_hash, :string)
      add(:role_id, references(:roles, on_delete: :nothing))

      timestamps()
    end

    create(index(:users, [:role_id]))
    create(unique_index(:users, [:email, :username]))
  end
end
