defmodule TimeManagerApiWeb.WorkingtimeView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.WorkingtimeView

  def render("index.json", %{workingtimes: workingtimes}) do
    %{data: render_many(workingtimes, WorkingtimeView, "workingtime.json")}
  end

  def render("show.json", %{workingtime: workingtime}) do
    %{data: render_one(workingtime, WorkingtimeView, "workingtime.json")}
  end

  def render("error.json", %{error: error_msg}) do
    %{
      error: error_msg
    }
  end

  def render("updated.json", %{num_updates: num_updates}) do
    %{
      data: %{
        row_updated: num_updates
      }
    }
  end

  def render("workingtime.json", %{workingtime: workingtime}) do
    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end,
      user_id: workingtime.user_id
    }
  end

  def render("workingtime_teams.json", %{workingtime: workingtime}) do
    %{
      id: workingtime.id,
      user_id: workingtime.user_id,
      team_id: workingtime.team_id,
      username: workingtime.username,
      email: workingtime.email,
      start: workingtime.start,
      end: workingtime.end
    }
  end

  def render("workingtimes_teams.json", %{workingtimes: workingtimes}) do
    %{data: render_many(workingtimes, WorkingtimeView, "workingtime_teams.json")}
  end

  def render("delete_wt.json", %{id: id, start: start, end: end_}) do
    %{detail: "Workingtime with #{id} ID (start: #{start} ; end: #{end_})deleted successfully."}
  end
end
