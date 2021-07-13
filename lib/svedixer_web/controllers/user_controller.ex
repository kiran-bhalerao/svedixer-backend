defmodule SvedixerWeb.UserController do
  use SvedixerWeb, :controller

  alias Svedixer.Account
  alias Svedixer.Account.User
  alias Svedixer.Guardian

  action_fallback(SvedixerWeb.FallbackController)

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Account.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        render(conn, "access_token.json", access_token: token)

      {:error, _} = err ->
        err
    end
  end

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      with {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
        render(conn, "access_token.json", access_token: token)
      end
    end
  end

  def me(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
