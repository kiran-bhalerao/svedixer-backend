defmodule Svedixer.Feed.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :published, :boolean, default: false
    field :title, :string

    belongs_to :author, Svedixer.Account.User
    has_many :likes, Svedixer.Feed.Like, foreign_key: :like_to_id
    has_many :comments, Svedixer.Feed.Comment, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published])
    |> validate_required([:title, :content, :author])
  end
end
