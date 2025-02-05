defmodule TimeManagerApi.OrganisationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Organisation` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManagerApi.Organisation.create_team()

    team
  end

  @doc """
  Generate a team_to_user.
  """
  def team_to_user_fixture(attrs \\ %{}) do
    {:ok, team_to_user} =
      attrs
      |> Enum.into(%{

      })
      |> TimeManagerApi.Organisation.create_team_to_user()

    team_to_user
  end
end
