defmodule TimeManagerApiWeb.Team_to_userController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Organisation
  alias TimeManagerApi.Organisation.Team_to_user

  action_fallback(TimeManagerApiWeb.FallbackController)

  def addUserToTeam(conn, params) do
    with {:ok, %Team_to_user{} = team_to_user} <-
           Organisation.add_user_to_team(params) do
      conn
      |> put_status(:created)
      |> render("show.json", team_to_user: team_to_user)
    end
  end

  def deleteUserFromTeam(conn, params) do
    with {:ok, %Team_to_user{} = team_to_users} <- Organisation.delete_user_from_team(params) do
      %{user_id: user_id, team_id: team_id} = team_to_users
      IO.inspect(team_to_users)

      conn
      |> put_status(:ok)
      |> render(
        "delete_team_to_user.json",
        %{user_id: user_id, team_id: team_id}
      )
    end
  end
end
