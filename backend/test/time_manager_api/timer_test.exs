defmodule TimeManagerApi.TimerTest do
  use TimeManagerApi.DataCase

  alias TimeManagerApi.Timer

  describe "workingtimes" do
    alias TimeManagerApi.Timer.Workingtime

    import TimeManagerApi.TimerFixtures

    @invalid_attrs %{}
    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert Timer.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Timer.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{}

      assert {:ok, %Workingtime{} = workingtime} = Timer.create_workingtime(valid_attrs)
      valid_attrs = %{end: ~N[2022-10-26 08:12:00], start: ~N[2022-10-26 08:12:00]}

      assert {:ok, %Workingtime{} = workingtime} = Timer.create_workingtime(valid_attrs)
      assert workingtime.end == ~N[2022-10-26 08:12:00]
      assert workingtime.start == ~N[2022-10-26 08:12:00]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timer.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{}

      assert {:ok, %Workingtime{} = workingtime} =
               Timer.update_workingtime(workingtime, update_attrs)

      update_attrs = %{end: ~N[2022-10-27 08:12:00], start: ~N[2022-10-27 08:12:00]}

      assert {:ok, %Workingtime{} = workingtime} =
               Timer.update_workingtime(workingtime, update_attrs)

      assert workingtime.end == ~N[2022-10-27 08:12:00]
      assert workingtime.start == ~N[2022-10-27 08:12:00]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = Timer.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == Timer.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = Timer.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Timer.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = Timer.change_workingtime(workingtime)
  describe "clocks" do
    alias TimeManagerApi.Timer.Clock

    import TimeManagerApi.TimerFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Timer.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Timer.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2022-10-26 08:02:00]}

      assert {:ok, %Clock{} = clock} = Timer.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2022-10-26 08:02:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timer.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2022-10-27 08:02:00]}

      assert {:ok, %Clock{} = clock} = Timer.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2022-10-27 08:02:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Timer.update_clock(clock, @invalid_attrs)
      assert clock == Timer.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Timer.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Timer.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Timer.change_clock(clock)
    end
  end
end
