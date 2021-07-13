defmodule SvedixerWeb.UserView do
  use SvedixerWeb, :view
  alias SvedixerWeb.UserView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("access_token.json", %{access_token: access_token}) do
    %{access_token: access_token}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end

  def render("message.json", %{message: message}) do
    %{message: message}
  end
end
