defmodule TimeManagerApiWeb.ClockView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.ClockView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock.json")}
  end

  def render("show.json", %{clock: clock}) do
    %{data: render_one(clock, ClockView, "clock.json")}
  end

  def render("clock.json", %{clock: clock}) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id
    }
  end

  def render("clock_teams.json", %{clock: clock}) do
    %{
      user_id: clock.user_id,
      team_id: clock.team_id,
      username: clock.username,
      email: clock.email,
      time: clock.time,
      status: clock.status
    }
  end

  def render("clocks_teams.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClockView, "clock_teams.json")}
  end
end
