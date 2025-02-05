defmodule TimeManagerApi.Organisation.Team_to_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_to_users" do
    field(:user_id, :id)
    field(:team_id, :id)

    timestamps()
  end

  @doc false
  def changeset(team_to_user, attrs) do
    team_to_user
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
    |> unique_constraint([:user_id, :team_id])
  end
end
