defmodule SvedixerWeb.CommentView do
  use SvedixerWeb, :view
  alias SvedixerWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id, comment: comment.comment}
  end

  def render("message.json", %{message: message}) do
    %{message: message}
  end
end
