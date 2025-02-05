defmodule TimeManagerApiWeb.UserView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role_id: user.role_id
    }
  end

  def render("delete_user.json", %{id: id, username: username}) do
    %{detail: "User #{username} with #{id} ID deleted successfully."}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{data: %{jwt: jwt}}
  end
end
