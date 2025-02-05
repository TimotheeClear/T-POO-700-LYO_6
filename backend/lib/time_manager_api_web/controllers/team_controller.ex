defmodule TimeManagerApiWeb.TeamController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Organisation
  alias TimeManagerApi.Organisation.Team

  action_fallback(TimeManagerApiWeb.FallbackController)

  def getAllTeams(conn, _params) do
    teams = Organisation.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def createTeam(conn, params) do
    with {:ok, %Team{} = team} <- Organisation.create_team(params) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  def getTeamById(conn, params) do
    with {:ok, %Team{} = team} <- Organisation.get_team!(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", team: team)
    end
  end

  def updateTeam(conn, params) do
    with {:ok, %Team{} = team} <- Organisation.update_team(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", team: team)
    end
  end

  def deleteTeam(conn, params) do
    with {:ok, %Team{} = team} <- Organisation.delete_team(params) do
      %{id: id, name: name} = team

      conn
      |> put_status(:ok)
      |> render("delete_team.json", %{id: id, name: name})
    end
  end

  def getTeamsWithUser(conn, params) do
    with {:ok, teams} <- Organisation.get_teams_with_user(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", teams: teams)
    end
  end
end
