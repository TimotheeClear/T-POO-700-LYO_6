defmodule TimeManagerApiWeb.Team_to_userControllerTest do
  use TimeManagerApiWeb.ConnCase

  import TimeManagerApi.OrganisationFixtures

  alias TimeManagerApi.Organisation.Team_to_user

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_to_users", %{conn: conn} do
      conn = get(conn, Routes.team_to_user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_to_user" do
    test "renders team_to_user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.team_to_user_path(conn, :create), team_to_user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.team_to_user_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.team_to_user_path(conn, :create), team_to_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_to_user" do
    setup [:create_team_to_user]

    test "renders team_to_user when data is valid", %{conn: conn, team_to_user: %Team_to_user{id: id} = team_to_user} do
      conn = put(conn, Routes.team_to_user_path(conn, :update, team_to_user), team_to_user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.team_to_user_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_to_user: team_to_user} do
      conn = put(conn, Routes.team_to_user_path(conn, :update, team_to_user), team_to_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_to_user" do
    setup [:create_team_to_user]

    test "deletes chosen team_to_user", %{conn: conn, team_to_user: team_to_user} do
      conn = delete(conn, Routes.team_to_user_path(conn, :delete, team_to_user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.team_to_user_path(conn, :show, team_to_user))
      end
    end
  end

  defp create_team_to_user(_) do
    team_to_user = team_to_user_fixture()
    %{team_to_user: team_to_user}
  end
end
