defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router
  alias TimeManagerApi.Guardian
  alias TimeManagerApi.Application.Authorization.VerifyUserIsSelf
  alias TimeManagerApi.Application.Authorization.VerifyUserIsManager
  alias TimeManagerApi.Application.Authorization.VerifyUserIsGeneralManager

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :jwt_authenticated do
    plug(Guardian.AuthPipeline)
  end

  pipeline :verify_user_is_self do
    plug(VerifyUserIsSelf)
  end

  pipeline :verify_user_is_manager do
    plug(VerifyUserIsManager)
  end

  pipeline :verify_user_is_general_manager do
    plug(VerifyUserIsGeneralManager)
  end

  # ***---- No auth routes ----***
  scope "/api", TimeManagerApiWeb do
    pipe_through(:api)

    #    auth
    post("/auth/signup", UserController, :signup)
    post("/auth/login", UserController, :login)

    # ------ Roles ------
    post("/roles", RoleController, :createRole)
    get("/roles/:user_id", RoleController, :getRoleById)
  end

  # ***---- User is self routes ----***
  scope "/api", TimeManagerApiWeb do
    pipe_through([:api, :jwt_authenticated, :verify_user_is_self])

    # ------ Users ------
    patch("/users/:user_id", UserController, :updateUser)
  end

  # ***---- User is manager routes ----***
  scope "/api", TimeManagerApiWeb do
    pipe_through([:api, :jwt_authenticated, :verify_user_is_manager])

    # ------ Users ------
    get("/users", UserController, :getAllUsers)

    # -- Users in team --
    get("/users/teams/:team_id", UserController, :getUsersByTeamId)
    # -- Users by role --
    get("/users/roles/:role_id", UserController, :getUsersByRoleId)

    # ------ Teams ------
    get("/teams", TeamController, :getAllTeams)
    get("/teams/:team_id", TeamController, :getTeamById)
    post("/teams", TeamController, :createTeam)
    put("/teams/:team_id", TeamController, :updateTeam)
    delete("/teams/:team_id", TeamController, :deleteTeam)
    # -- Teams with user --
    get("/teams/users/:user_id", TeamController, :getTeamsWithUser)

    # ------ Teams & users ------
    post("/teams/:team_id/users/:user_id", Team_to_userController, :addUserToTeam)
    delete("/teams/:team_id/users/:user_id", Team_to_userController, :deleteUserFromTeam)

    # ------ Workingtimes ------
    get("/workingtimes/teams/:team_id", WorkingtimeController, :getWorkingtimesByTeamId)

    # ------ Clocks ------
    get("/clocks/teams/:team_id", ClockController, :getClocksByTeamId)
  end

  # ***---- User is authenticated routes ----***
  scope "/api", TimeManagerApiWeb do
    pipe_through([:api, :jwt_authenticated])

    # ------ Users ------
    get("/users/:user_id", UserController, :getUserById)
    delete("/users/:user_id", UserController, :deleteUser)

    # ------ Workingtimes ------
    post("/workingtimes/:user_id", WorkingtimeController, :addWorkingtimeByUserId)
    delete("/workingtimes/:workingtime_id", WorkingtimeController, :deleteWorkingtime)
    get("/workingtimes/all/:user_id", WorkingtimeController, :getWorkingtimesByUserId)
    get("/workingtimes/:user_id", WorkingtimeController, :getWorkingtimesByUserIdOnPeriod)
    patch("/workingtimes/:workingtime_id", WorkingtimeController, :updateWorkingtime)

    get(
      "/workingtimes/:workingtime_id/users/:user_id",
      WorkingtimeController,
      :getOneWorkingtimeByUserId
    )

    # ------ Clocks ------
    get("/clocks/:user_id", ClockController, :getAllClocksByUser)
    get("/clocks/span/:user_id", ClockController, :getAllClocksByUserByPeriod)
    post("/clocks/:user_id", ClockController, :createClockForUser)
    get("/clocks/last/:user_id", ClockController, :getLastClockByUser)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimeManagerApiWeb.Telemetry)
    end
  end
end
