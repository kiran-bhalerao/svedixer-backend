defmodule SvedixerWeb.CommentController do
  use SvedixerWeb, :controller

  alias Svedixer.Feed
  alias Svedixer.Feed.Comment

  action_fallback SvedixerWeb.FallbackController

  def create(conn, %{"post_id" => post_id, "comment" => comment}) do
    user = Guardian.Plug.current_resource(conn)

    try do
      post = Feed.get_post!(post_id)

      with {:ok, %Comment{} = comment} <- Feed.create_comment(post, user, comment) do
        conn
        |> put_status(:created)
        |> render("show.json", comment: comment)
      end
    rescue
      _ ->
        conn
        |> put_status(:forbidden)
        |> render("message.json", message: "Failed to create this comment")
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_text}) do
    user = Guardian.Plug.current_resource(conn)
    comment = Feed.get_comment_by_user(user.id, id)

    with {:ok, %Comment{} = comment} <- Feed.update_comment(comment, %{"comment" => comment_text}) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)

    try do
      comment = Feed.get_comment_by_user(user.id, id)

      with {:ok, %Comment{}} <- Feed.delete_comment(comment) do
        render(conn, "message.json", message: "Comment deleted")
      end
    rescue
      _ ->
        conn
        |> put_status(:forbidden)
        |> render("message.json", message: "Failed to delete this comment")
    end
  end
end
