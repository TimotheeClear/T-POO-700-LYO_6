defmodule TimeManagerApi.Account do
  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo

  alias TimeManagerApi.Account.User
  alias TimeManagerApi.Account.Role

  alias TimeManagerApi.Guardian

  # ------ Auth functions ------
  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        claims = %{
          user: %{
            id: user.id,
            role_id: user.role_id,
            email: user.email,
            username: user.username
          }
        }

        Guardian.encode_and_sign(user, claims)

      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
         do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "Login error."}

      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  # ------ User functions ------
  def list_users() do
    users = Repo.all(User)

    case users do
      [] -> {:error, :no_content}
      _ -> {:ok, users}
    end
  end

  def get_user!(attrs) do
    try do
      %{"user_id" => user_id} = attrs
      {parsed_id, ""} = Integer.parse(user_id)

      user = Repo.get!(User, parsed_id)
      {:ok, user}
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in Ecto.NoResultsError ->
        {:error, :no_content}
    end
  end

  def create_user(attrs \\ %{}) do
    try do
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    rescue
      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}

      _ in ArgumentError ->
        {:error, :password_hash}
    end
  end

  def update_user(attrs) do
    try do
      response = get_user!(attrs)

      case response do
        {:ok, user} ->
          user
          |> User.update_changeset(attrs)
          |> Repo.update()

        {:error, :no_content} ->
          {:error, :no_content}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in ArgumentError ->
        {:error, :password_hash}

      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}
    end
  end

  def delete_user(attrs) do
    try do
      response = get_user!(attrs)

      case response do
        {:ok, user} ->
          Repo.delete(user)

        {:error, :no_content} ->
          {:error, :no_content}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attibutes}
    end
  end

  def get_users_by_role_id(params) do
    try do
      %{"role_id" => role_id} = params
      {parsed_id, ""} = Integer.parse(role_id)

      query =
        from(u in "users",
          where: u.role_id == ^parsed_id,
          select: %{
            id: u.id,
            username: u.username,
            email: u.email,
            password_hash: u.password_hash,
            role_id: u.role_id,
            inserted_at: u.inserted_at,
            updated_at: u.updated_at
          }
        )

      users =
        Repo.all(query)
        |> Enum.map(fn user ->
          struct(User, user)
        end)

      case users do
        [] -> {:error, :no_content}
        _ -> {:ok, users}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def get_users_by_team_id(attrs) do
    try do
      %{"team_id" => team_id} = attrs
      {parsed_id, ""} = Integer.parse(team_id)

      query =
        from(tu in "team_to_users",
          join: u in "users",
          on: tu.user_id == u.id,
          where: tu.team_id == ^parsed_id,
          select: %{
            id: u.id,
            username: u.username,
            email: u.email,
            role_id: u.role_id,
            inserted_at: u.inserted_at,
            updated_at: u.updated_at
          }
        )

      users =
        Repo.all(query)
        |> Enum.map(fn user ->
          struct(User, user)
        end)

      case users do
        [] -> {:error, :no_content}
        _ -> {:ok, users}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  # ------ Role functions ------
  def create_role(attrs \\ %{}) do
    try do
      %Role{}
      |> Role.changeset(attrs)
      |> Repo.insert()
    rescue
      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}
    end
  end

  def get_role!(id) do
    try do
      response = Repo.get!(Role, id)
      {:ok, response}
    rescue
      _ in Ecto.NoResultsError ->
        {:error, :no_content}
    end
  end
end
