defmodule TimeManagerApiWeb.Team_to_userView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.Team_to_userView

  def render("index.json", %{team_to_users: team_to_users}) do
    %{data: render_many(team_to_users, Team_to_userView, "team_to_user.json")}
  end

  def render("show.json", %{team_to_user: team_to_user}) do
    %{data: render_one(team_to_user, Team_to_userView, "team_to_user.json")}
  end

  def render("team_to_user.json", %{team_to_user: team_to_user}) do
    %{
      id: team_to_user.id,
      user_id: team_to_user.user_id,
      team_id: team_to_user.team_id
    }
  end

  def render("delete_team_to_user.json", %{user_id: user_id, team_id: team_id}) do
    %{detail: "User with #{user_id} ID removed from team #{team_id} ID successfully."}
  end
end
