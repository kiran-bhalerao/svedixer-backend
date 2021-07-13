defmodule SvedixerWeb.PostController do
  use SvedixerWeb, :controller

  alias Svedixer.Feed
  alias Svedixer.Feed.Post
  alias Svedixer.Guardian

  action_fallback SvedixerWeb.FallbackController

  @doc """
    List of Most liked posts
  """
  def home_feed(conn, _params) do
    posts = Feed.posts_sort_by_like_count()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Post{} = post} <- Feed.create_post(user, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Feed.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def user_feed(conn, %{"user_id" => id}) do
    posts = Feed.get_posts_by_user(id)
    render(conn, "index.json", posts: posts)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Feed.get_post!(id)

    with {:ok, %Post{} = post} <- Feed.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Feed.get_post!(id)

    with {:ok, %Post{}} <- Feed.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
