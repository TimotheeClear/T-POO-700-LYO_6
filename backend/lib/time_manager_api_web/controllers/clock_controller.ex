defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Timer
  alias TimeManagerApi.Timer.Clock

  action_fallback(TimeManagerApiWeb.FallbackController)

  def getAllClocksByUserByPeriod(conn, %{"user_id" => user_id, "start" => start, "end" => end_}) do
    with {:ok, clocks} <-
           Timer.get_all_clocks_by_period(user_id, start, end_) do
      conn
      |> put_status(:ok)
      |> render("index.json", clocks: clocks)
    end
  end

  def getAllClocksByUser(conn, params) do
    with {:ok, clocks} <- Timer.get_clocks_by_user(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", clocks: clocks)
    end
  end

  def getLastClockByUser(conn, params) do
    with {:ok, %Clock{} = clock} <- Timer.get_last_clock_by_user(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", clock: clock)
    end
  end

  def createClockForUser(conn, params) do
    with {:ok, %Clock{} = clock} <- Timer.create_clock_for_user(params) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end

  def getClocksByTeamId(conn, params) do
    with {:ok, clocks} <- Timer.get_clocks_by_team_id(params) do
      conn
      |> put_status(:ok)
      |> render("clocks_teams.json", clocks: clocks)
    end
  end
end
