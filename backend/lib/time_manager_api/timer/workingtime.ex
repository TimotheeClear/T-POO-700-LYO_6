defmodule TimeManagerApi.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field(:end, :naive_datetime)
    field(:start, :naive_datetime)
    field(:user_id, :id)

    timestamps()
  end

  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end, :user_id])
    |> unique_constraint([:start, :end, :user_id])
  end
end
