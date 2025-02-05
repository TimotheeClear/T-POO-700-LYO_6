defmodule TimeManagerApi.TimerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Timer` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~N[2022-10-26 08:12:00],
        start: ~N[2022-10-26 08:12:00]
      })
      |> TimeManagerApi.Timer.create_workingtime()

    workingtime
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2022-10-26 08:02:00]
      })
      |> TimeManagerApi.Timer.create_clock()

    clock
  end
end
