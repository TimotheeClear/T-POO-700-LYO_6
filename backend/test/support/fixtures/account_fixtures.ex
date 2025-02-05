defmodule TimeManagerApi.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password",
        role_id: 42,
        username: "some username"
      })
      |> TimeManagerApi.Account.create_user()

    user
  end
end
