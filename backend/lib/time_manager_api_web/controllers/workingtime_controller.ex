defmodule TimeManagerApiWeb.WorkingtimeController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Timer
  alias TimeManagerApi.Workingtime

  action_fallback(TimeManagerApiWeb.FallbackController)

  def getWorkingtimesByUserIdOnPeriod(conn, %{
        "user_id" => user_id,
        "start" => start,
        "end" => end_
      }) do
    with {:ok, wts} <-
           Timer.get_workingtimes_by_user_id_on_period(user_id, start, end_) do
      conn
      |> put_status(:ok)
      |> render("index.json", workingtimes: wts)
    end
  end

  def getWorkingtimesByUserId(conn, params) do
    with {:ok, wts} <- Timer.get_workingtimes_by_user_id(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", workingtimes: wts)
    end
  end

  def getOneWorkingtimeByUserId(conn, params) do
    with {:ok, %Workingtime{} = wt} <-
           Timer.get_one_workingtime_by_user_id(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", workingtime: wt)
    end
  end

  def addWorkingtimeByUserId(conn, params) do
    with {:ok, %Workingtime{} = wt} <- Timer.add_workingtime_by_user_id(params) do
      conn
      |> put_status(:created)
      |> render("show.json", workingtime: wt)
    end
  end

  def updateWorkingtime(conn, params) do
    with {:ok, num_updates} <- Timer.update_workingtime(params) do
      conn
      |> put_status(:ok)
      |> render("updated.json", num_updates: num_updates)
    end
  end

  def deleteWorkingtime(conn, params) do
    with {:ok, wt} <- Timer.delete_workingtime(params) do
      %{id: id, start: start, end: end_} = wt

      conn
      |> put_status(:ok)
      |> render(
        "delete_wt.json",
        %{id: id, start: start, end: end_}
      )
    end
  end

  def getWorkingtimesByTeamId(conn, params) do
    with {:ok, wts} <- Timer.get_workingtimes_by_team_id(params) do
      conn
      |> put_status(:ok)
      |> render("workingtimes_teams.json", %{workingtimes: wts})
    end
  end
end
