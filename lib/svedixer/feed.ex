defmodule Svedixer.Feed do
  @moduledoc """
  The Feed context.
  """

  import Ecto.Query, warn: false
  alias Svedixer.Repo

  alias Svedixer.Feed.Post
  alias Svedixer.Feed.Like
  alias Svedixer.Feed.Comment

  def get_posts_by_user(id) do
    query =
      from p in Post,
        where: p.author_id == ^id

    Repo.all(query)
  end

  def posts_sort_by_like_count() do
    # select count(posts.id) as c, posts.id, posts.title
    # from posts left join likes on likes.like_to_id = posts.id
    # group by posts.id order by c desc;

    query =
      from p in Post,
        left_join: l in assoc(p, :likes),
        group_by: p.id,
        order_by: [desc: count(p.id)]

    Repo.all(query)
  end

  def get_post!(id) do
    Repo.get!(Post, id) |> Repo.preload(:author)
  end

  def create_post(author, attrs \\ %{}) do
    %Post{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:author, author)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def get_like!(id), do: Repo.get!(Like, id)

  def get_like_by_user(user_id, like_id) do
    query =
      from l in Svedixer.Feed.Like,
        join: u in assoc(l, :like_by),
        on: u.id == ^user_id,
        where: l.id == ^like_id

    Repo.one(query)
  end

  def create_like(like_by, like_to) do
    %Like{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:like_to, like_to)
    |> Ecto.Changeset.put_assoc(:like_by, like_by)
    |> Like.changeset()
    |> Repo.insert()
  end

  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def get_comment_by_user(user_id, comment_id) do
    query =
      from c in Svedixer.Feed.Comment,
        join: u in assoc(c, :commenter),
        on: u.id == ^user_id,
        where: c.id == ^comment_id,
        preload: [:post, :commenter]

    Repo.one(query)
  end

  def create_comment(post, user, comment) do
    %Comment{}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:post, post)
    |> Ecto.Changeset.put_assoc(:commenter, user)
    |> Comment.changeset(%{"comment" => comment})
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
