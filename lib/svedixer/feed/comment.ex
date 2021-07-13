defmodule Svedixer.Feed.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :comment, :string

    belongs_to :post, Svedixer.Feed.Post
    belongs_to :commenter, Svedixer.Account.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment])
    |> validate_required([:comment, :post, :commenter])
  end
end
