defmodule TimeManagerApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :TimeManagerApi,
                              module: TimeManagerApi.Guardian,
                              error_handler: TimeManagerApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
