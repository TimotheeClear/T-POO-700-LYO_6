defmodule TimeManagerApiWeb.RoleView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.RoleView

  def render("index.json", %{roles: roles}) do
    %{data: render_many(roles, RoleView, "role.json")}
  end

  def render("show.json", %{role: role}) do
    %{data: render_one(role, RoleView, "role.json")}
  end

  def render("role.json", %{role: role}) do
    %{
      id: role.id,
      name: role.name
    }
  end

  def render("error.json", %{error: error_msg}) do
    %{
      error: error_msg
    }
  end
end
