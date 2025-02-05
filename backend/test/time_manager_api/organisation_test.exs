defmodule TimeManagerApi.OrganisationTest do
  use TimeManagerApi.DataCase

  alias TimeManagerApi.Organisation

  describe "teams" do
    alias TimeManagerApi.Organisation.Team

    import TimeManagerApi.OrganisationFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Organisation.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Organisation.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Organisation.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisation.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Organisation.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Organisation.update_team(team, @invalid_attrs)
      assert team == Organisation.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Organisation.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Organisation.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Organisation.change_team(team)
    end
  end

  describe "team_to_users" do
    alias TimeManagerApi.Organisation.Team_to_user

    import TimeManagerApi.OrganisationFixtures

    @invalid_attrs %{}

    test "list_team_to_users/0 returns all team_to_users" do
      team_to_user = team_to_user_fixture()
      assert Organisation.list_team_to_users() == [team_to_user]
    end

    test "get_team_to_user!/1 returns the team_to_user with given id" do
      team_to_user = team_to_user_fixture()
      assert Organisation.get_team_to_user!(team_to_user.id) == team_to_user
    end

    test "create_team_to_user/1 with valid data creates a team_to_user" do
      valid_attrs = %{}

      assert {:ok, %Team_to_user{} = team_to_user} = Organisation.create_team_to_user(valid_attrs)
    end

    test "create_team_to_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisation.create_team_to_user(@invalid_attrs)
    end

    test "update_team_to_user/2 with valid data updates the team_to_user" do
      team_to_user = team_to_user_fixture()
      update_attrs = %{}

      assert {:ok, %Team_to_user{} = team_to_user} = Organisation.update_team_to_user(team_to_user, update_attrs)
    end

    test "update_team_to_user/2 with invalid data returns error changeset" do
      team_to_user = team_to_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Organisation.update_team_to_user(team_to_user, @invalid_attrs)
      assert team_to_user == Organisation.get_team_to_user!(team_to_user.id)
    end

    test "delete_team_to_user/1 deletes the team_to_user" do
      team_to_user = team_to_user_fixture()
      assert {:ok, %Team_to_user{}} = Organisation.delete_team_to_user(team_to_user)
      assert_raise Ecto.NoResultsError, fn -> Organisation.get_team_to_user!(team_to_user.id) end
    end

    test "change_team_to_user/1 returns a team_to_user changeset" do
      team_to_user = team_to_user_fixture()
      assert %Ecto.Changeset{} = Organisation.change_team_to_user(team_to_user)
    end
  end
end
