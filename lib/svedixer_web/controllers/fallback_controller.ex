defmodule SvedixerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SvedixerWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(SvedixerWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # Handle unauthirized error
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "unauthorized"})
  end

  # Handle invalid login credentials error
  def call(conn, {:error, :invalid_creds}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "invalid credentials"})
  end

  # Handle all other error
  def call(conn, {:error, str}) when is_binary(str) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: str})
  end
end
