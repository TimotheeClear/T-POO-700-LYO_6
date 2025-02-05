defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.Account
  alias TimeManagerApi.Account.User

  action_fallback(TimeManagerApiWeb.FallbackController)

  # ------ Signup / Login ------
  def signup(conn, params) do
    with {:ok, %User{} = user} <- Account.create_user(params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    Account.token_sign_in(email, password)
    |> IO.inspect()

    case Account.token_sign_in(email, password) do
      {:ok, token, claims} ->
        conn
        |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  # ------ Users ------
  def getAllUsers(conn, _params) do
    with {:ok, users} <- Account.list_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def getUserById(conn, params) do
    with {:ok, %User{} = user} <- Account.get_user!(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def getUsersByRoleId(conn, params) do
    with {:ok, users} <- Account.get_users_by_role_id(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def updateUser(conn, params) do
    with {:ok, %User{} = user} <-
           Account.update_user(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def deleteUser(conn, params) do
    with {:ok, %User{} = user} <- Account.delete_user(params) do
      %{id: id, username: username} = user

      conn
      |> put_status(:ok)
      |> render("delete_user.json", %{id: id, username: username})
    end
  end

  def getUsersByTeamId(conn, params) do
    with {:ok, users} <- Account.get_users_by_team_id(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def getCurrentUser(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end
end
