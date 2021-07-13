defmodule Svedixer.Feed.Like do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "likes" do
    belongs_to :like_by, Svedixer.Account.User
    belongs_to :like_to, Svedixer.Feed.Post

    timestamps()
  end

  @doc false
  def changeset(like, attrs \\ %{}) do
    like
    |> cast(attrs, [])
    |> validate_required([:like_by, :like_to])
  end
end
