defmodule TimeManagerApi.Application.Authorization.VerifyUserIsSelf do
  use Guardian
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    [token] = get_req_header(conn, "authorization")
    regex = ~r/^Bearer (.+)/
    [_, pattern] = Regex.run(regex, token)

    {:ok, claims} = TimeManagerApi.Guardian.decode_and_verify(pattern)
    %{"user" => %{"id" => id, "role_id" => role_id}} = claims

    # Get user ID
    %{"user_id" => user_id} = conn.params

    cond do
      String.to_integer(user_id) == id -> conn
      role_id == 3 -> conn
      true ->
        conn
        |> send_resp(
             401,
             "You are not authorized to access this resource."
           )
        |> halt()
    end
  end
end
