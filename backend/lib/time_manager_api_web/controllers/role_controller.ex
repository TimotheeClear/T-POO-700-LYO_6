defmodule TimeManagerApiWeb.RoleController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Account
  alias TimeManagerApi.Account.Role

  action_fallback(TimeManagerApiWeb.FallbackController)

  def createRole(conn, params) do
    with {:ok, %Role{} = role} <- Account.create_role(params) do
      conn
      |> put_status(:created)
      |> render("show.json", role: role)
    end
  end

  def getRoleById(conn, %{"user_id" => user_id}) do
    with {:ok, role} <- Account.get_role!(user_id) do
      conn
      |> render("show.json", role: role)
    end
  end
end
