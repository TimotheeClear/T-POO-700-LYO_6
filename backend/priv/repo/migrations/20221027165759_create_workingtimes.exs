defmodule TimeManagerApi.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add(:start, :naive_datetime)
      add(:end, :naive_datetime)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:workingtimes, [:user_id]))

    create(
      unique_index(
        :workingtimes,
        [:start, :end, :user_id],
        name: :one_start_end_couple
      )
    )
  end
end
