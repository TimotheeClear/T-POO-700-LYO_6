defmodule TimeManagerApi.Organisation do
  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Account.User
  alias TimeManagerApi.Account.Team_to_user
  alias TimeManagerApi.Organisation.Team
  alias TimeManagerApi.Organisation.Team_to_user

  # ------ Team functions ------

  def list_teams do
    Repo.all(Team)
  end

  def get_team!(attrs) do
    try do
      %{"team_id" => team_id} = attrs
      {parsed_id, ""} = Integer.parse(team_id)

      team = Repo.get!(Team, parsed_id)
      {:ok, team}
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in Ecto.NoResultsError ->
        {:error, :no_content}
    end
  end

  def create_team(attrs \\ %{}) do
    try do
      %Team{}
      |> Team.changeset(attrs)
      |> Repo.insert()
    rescue
      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}
    end
  end

  def update_team(attrs) do
    try do
      response = get_team!(attrs)

      case response do
        {:ok, team} ->
          team
          |> Team.changeset(attrs)
          |> Repo.update()

        {:error, :no_content} ->
          {:error, :no_content}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def delete_team(attrs) do
    try do
      response = get_team!(attrs)

      case response do
        {:ok, team} ->
          Repo.delete(team)

        {:error, :no_content} ->
          {:error, :no_content}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attibutes}
    end
  end

  # ------ Team & users ------

  def add_user_to_team(attrs) do
    try do
      %{"team_id" => _, "user_id" => _} = attrs

      %Team_to_user{}
      |> Team_to_user.changeset(attrs)
      |> Repo.insert()
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}
    end
  end

  def delete_user_from_team(attrs) do
    try do
      %{"user_id" => user_id, "team_id" => team_id} = attrs
      {parsed_user_id, ""} = Integer.parse(user_id)
      {parsed_team_id, ""} = Integer.parse(team_id)

      query =
        from(tu in "team_to_users",
          where: tu.user_id == ^parsed_user_id and tu.team_id == ^parsed_team_id,
          select: %{
            id: tu.id,
            team_id: tu.team_id,
            user_id: tu.user_id,
            inserted_at: tu.inserted_at,
            updated_at: tu.updated_at
          }
        )

      user_in_team = Repo.one(query)

      case user_in_team do
        nil ->
          {:error, :no_content}

        _ ->
          struct(Team_to_user, user_in_team)
          |> Repo.delete()
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def get_teams_with_user(attrs) do
    try do
      %{"user_id" => user_id} = attrs
      {parsed_id, ""} = Integer.parse(user_id)

      query =
        from(tu in "team_to_users",
          join: t in "teams",
          on: tu.team_id == t.id,
          where: tu.user_id == ^parsed_id,
          select: %{
            id: t.id,
            name: t.name
          }
        )

      teams =
        Repo.all(query)
        |> Enum.map(fn team ->
          struct(Team, team)
        end)

      case teams do
        [] -> {:error, :no_content}
        _ -> {:ok, teams}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def get_team_to_user_by_team_id_user_id!(team_id, user_id) do
    query =
      from(tu in "team_to_users",
        where: tu.team_id == ^team_id and tu.user_id == ^user_id,
        select: tu.id
      )

    id = Repo.one(query)
    Repo.get!(Team_to_user, id)
  end

  def get_users_by_team_id(team_id) do
    query =
      from(tu in "team_to_users",
        join: u in "users",
        on: tu.user_id == u.id,
        where: tu.team_id == ^team_id,
        select: %{
          id: u.id,
          username: u.username,
          email: u.email,
          password: u.password,
          role_id: u.role_id,
          inserted_at: u.inserted_at,
          updated_at: u.updated_at
        }
      )

    users = Repo.all(query)

    Enum.map(users, fn user ->
      struct(User, user)
    end)
  end

  def get_teams_by_user_id(user_id) do
    query =
      from(tu in "team_to_users",
        join: t in "teams",
        on: tu.team_id == t.id,
        where: tu.user_id == ^user_id,
        select: %{
          id: t.id,
          name: t.name,
          inserted_at: t.inserted_at,
          updated_at: t.updated_at
        }
      )

    teams = Repo.all(query)

    Enum.map(teams, fn team ->
      struct(Team, team)
    end)
  end
end
