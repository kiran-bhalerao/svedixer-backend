defmodule SvedixerWeb.LikeController do
  use SvedixerWeb, :controller

  alias Svedixer.Feed
  alias Svedixer.Feed.Like

  action_fallback SvedixerWeb.FallbackController

  def create(conn, %{"post_id" => post_id}) do
    user = Guardian.Plug.current_resource(conn)

    try do
      post = Feed.get_post!(post_id)

      with {:ok, %Like{} = like} <- Feed.create_like(user, post) do
        conn
        |> put_status(:created)
        |> render("show.json", like: like)
      end
    rescue
      _ ->
        conn
        |> put_status(:forbidden)
        |> render("message.json", message: "Unable to like this post")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)

    try do
      like = Feed.get_like_by_user(user.id, id)

      with {:ok, %Like{}} <- Feed.delete_like(like) do
        render(conn, "message.json", message: "Unliked post")
      end
    rescue
      _ ->
        conn
        |> put_status(:forbidden)
        |> render("message.json", message: "Unable to unlike this post")
    end
  end
end
