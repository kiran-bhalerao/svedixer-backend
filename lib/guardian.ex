## Guardian Auth error handler
defmodule Svedixer.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end

## Guardian Auth pipline
defmodule Svedixer.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :Svedixer,
    module: Svedixer.Guardian,
    error_handler: Svedixer.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

defmodule Svedixer.Guardian do
  use Guardian, otp_app: :svedixer

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Svedixer.Account.get_user!(id)

    {:ok, resource}
  end
end
