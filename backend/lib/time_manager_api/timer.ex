defmodule TimeManagerApi.Timer do
  import Ecto.Query, warn: false

  alias TimeManagerApi.Repo
  alias TimeManagerApi.Workingtime
  alias TimeManagerApi.Timer.Clock

  # ------ Workingtimes ------
  def get_workingtimes_by_user_id(attrs) do
    try do
      %{"user_id" => user_id} = attrs
      {parsed_id, ""} = Integer.parse(user_id)

      query =
        from(wt in "workingtimes",
          where: wt.user_id == ^parsed_id,
          select: %{
            id: wt.id,
            start: wt.start,
            end: wt.end,
            user_id: wt.user_id,
            inserted_at: wt.inserted_at,
            updated_at: wt.updated_at
          }
        )

      wts = Repo.all(query)

      cond do
        wts == [] ->
          {:error, :no_content}

        true ->
          {:ok,
           Enum.map(wts, fn wt ->
             struct(Workingtime, wt)
           end)}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def get_one_workingtime_by_user_id(attrs) do
    try do
      %{"user_id" => user_id, "workingtime_id" => workingtime_id} = attrs
      {parsed_user_id, ""} = Integer.parse(user_id)
      {parsed_workingtime_id, ""} = Integer.parse(workingtime_id)

      query =
        from(wt in "workingtimes",
          where:
            wt.user_id == ^parsed_user_id and
              wt.id == ^parsed_workingtime_id,
          select: %{
            id: wt.id,
            start: wt.start,
            end: wt.end,
            user_id: wt.user_id,
            inserted_at: wt.inserted_at,
            updated_at: wt.updated_at
          }
        )

      wt = Repo.one(query)

      case wt do
        nil -> {:error, :no_content}
        _ -> {:ok, struct(Workingtime, wt)}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def add_workingtime_by_user_id(attrs) do
    try do
      %{"user_id" => user_id, "start" => start, "end" => end_} = attrs
      {parsed_id, ""} = Integer.parse(user_id)

      cond do
        start > end_ ->
          {:error, :time_order}

        true ->
          %Workingtime{user_id: parsed_id}
          |> Workingtime.changeset(attrs)
          |> Repo.insert()
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}
    end
  end

  def get_workingtimes_by_user_id_on_period(user_id, start, end_) do
    try do
      {parsed_id, ""} = Integer.parse(user_id)
      start = NaiveDateTime.from_iso8601!(start)
      end_ = NaiveDateTime.from_iso8601!(end_)

      query =
        from(w in "workingtimes",
          where: w.start >= ^start and w.end <= ^end_ and w.user_id == ^parsed_id,
          select: %{
            id: w.id,
            start: w.start,
            end: w.end,
            user_id: w.user_id
          }
        )

      wts = Repo.all(query)

      cond do
        start > end_ ->
          {:error, :time_order}

        wts == [] ->
          {:error, :no_content}

        true ->
          {:ok, wts}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in ArgumentError ->
        {:error, :time_format}
    end
  end

  def get_workingtimes_by_team_id(attrs) do
    try do
      %{"team_id" => team_id} = attrs
      {parsed_id, ""} = Integer.parse(team_id)

      query =
        from(tu in "team_to_users",
          join: u in "users",
          on: tu.user_id == u.id,
          join: w in "workingtimes",
          on: w.user_id == u.id,
          where: tu.team_id == ^parsed_id,
          select: %{
            id: w.id,
            user_id: tu.user_id,
            team_id: tu.team_id,
            username: u.username,
            email: u.email,
            start: w.start,
            end: w.end
          }
        )

      wts = Repo.all(query)

      case wts do
        [] -> {:error, :no_content}
        _ -> {:ok, wts}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def delete_workingtime(attrs) do
    try do
      %{"workingtime_id" => workingtime_id} = attrs
      {parsed_id, ""} = Integer.parse(workingtime_id)

      query =
        from(wt in "workingtimes",
          where: wt.id == ^parsed_id,
          select: %{
            id: wt.id,
            start: wt.start,
            end: wt.end,
            user_id: wt.user_id,
            inserted_at: wt.inserted_at,
            updated_at: wt.updated_at
          }
        )

      wt = Repo.one(query)

      case wt do
        nil ->
          {:error, :no_content}

        _ ->
          struct(Workingtime, wt)
          |> Repo.delete()
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def update_workingtime(attrs) do
    try do
      %{
        "workingtime_id" => workingtime_id,
        "start" => start,
        "end" => end_
      } = attrs

      {parsed_workingtime_id, ""} = Integer.parse(workingtime_id)

      {num_updates, nil} =
        from(w in Workingtime,
          where: w.id == ^parsed_workingtime_id,
          update: [set: [start: ^start, end: ^end_]]
        )
        |> Repo.update_all([])

      {:ok, num_updates}
    rescue
      _ in Ecto.NoResultsError ->
        {:error, :no_content}

      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}

      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  # ------ Clocks ------
  def create_clock_for_user(attrs) do
    # Set date now
    {:ok, now} = DateTime.now("Etc/UTC")
    %{"user_id" => user_id} = attrs

    try do
      # Retrieve last clock from DB
      [lastClock] = get_last_clock_from_user(user_id)

      # Prepare clock attributes
      %{status: status} = lastClock

      # Create the clock
      create_clock!(%{
        "status" => !status,
        "time" => now,
        "user_id" => user_id
      })
    rescue
      _ in MatchError ->
        create_clock!(%{
          "status" => true,
          "time" => now,
          "user_id" => user_id
        })
    end
  end

  def get_clocks_by_user(attrs) do
    try do
      %{"user_id" => user_id} = attrs
      {parsed_id, ""} = Integer.parse(user_id)

      query =
        from(c in Clock,
          where: c.user_id == ^parsed_id,
          select: %{
            id: c.id,
            status: c.status,
            time: c.time,
            user_id: c.user_id
          },
          order_by: [asc: c.id],
        )

      clocks = Repo.all(query)

      case clocks do
        [] -> {:error, :no_content}
        _ -> {:ok, clocks}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  def get_last_clock_by_user(attrs) do
    try do
      %{"user_id" => user_id} = attrs
      {parsed_id, ""} = Integer.parse(user_id)
      [lastClock] = get_last_clock_from_user(parsed_id)
      {:ok, lastClock}
    rescue
      _ in Ecto.ConstraintError ->
        {:error, :key_constraint}

      _ in MatchError ->
        {:error, :no_content}
    end
  end

  def get_all_clocks_by_period(user_id, start, end_) do
    try do
      {parsed_id, ""} = Integer.parse(user_id)
      start = NaiveDateTime.from_iso8601!(start)
      end_ = NaiveDateTime.from_iso8601!(end_)

      query =
        from(c in Clock,
          where: c.time >= ^start and c.time <= ^end_ and c.user_id == ^parsed_id,
          select: %{
            id: c.id,
            time: c.time,
            status: c.status,
            user_id: c.user_id
          }
        )

      clocks = Repo.all(query)

      case clocks do
        [] -> {:error, :no_content}
        _ -> {:ok, clocks}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}

      _ in ArgumentError ->
        {:error, :time_format}
    end
  end

  def get_clocks_by_team_id(attrs) do
    try do
      %{"team_id" => team_id} = attrs
      {parsed_id, ""} = Integer.parse(team_id)

      query =
        from(tu in "team_to_users",
          join: u in "users",
          on: tu.user_id == u.id,
          join: c in "clocks",
          on: c.user_id == u.id,
          where: tu.team_id == ^parsed_id,
          select: %{
            user_id: tu.user_id,
            team_id: tu.team_id,
            username: u.username,
            email: u.email,
            time: c.time,
            status: c.status
          },
          order_by: [asc: c.id],
        )

      clocks = Repo.all(query)

      case clocks do
        [] -> {:error, :no_content}
        _ -> {:ok, clocks}
      end
    rescue
      _ in MatchError ->
        {:error, :unmatched_attributes}
    end
  end

  # ------ Custom functions ------
  defp create_clock!(attrs) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def get_last_clock_from_user(user_id) do
    query =
      from(
        c in Clock,
        where:
          c.id ==
            all(
              from(
                c in Clock,
                select: max(c.id),
                where: c.user_id == ^user_id
              )
            )
      )

    Repo.all(query)
  end
end
