defmodule TimeManagerApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TimeManagerApiWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TimeManagerApiWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :no_content}) do
    conn
    |> put_status(:not_found)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render("custom_error.json",
      msg: "No corresponding result found in database.",
      status: 404
    )
  end

  def call(conn, {:error, :key_constraint}) do
    conn
    |> put_status(:not_found)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "Constraint foreign key error.",
      status: 404
    )
  end

  def call(conn, {:error, :unmatched_attributes}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "Attribute in request body is unmatched.",
      status: 422
    )
  end

  def call(conn, {:error, :password_hash}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "User should provide a password.",
      status: 422
    )
  end

  def call(conn, {:error, :time_error}) do
    conn
    |> put_status(:not_implemented)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "Special error with time.",
      status: 501
    )
  end

  def call(conn, {:error, :time_format}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "Invalid datetime format.",
      status: 422
    )
  end

  def call(conn, {:error, :time_order}) do
    conn
    |> put_status(:bad_request)
    |> put_view(TimeManagerApiWeb.ErrorView)
    |> render(
      "custom_error.json",
      msg: "Start time cannot be inferior to end time.",
      status: 400
    )
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Login error"})
  end
end
