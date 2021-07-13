defmodule Svedixer.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password_hash, :string

    has_many :posts, Svedixer.Feed.Post, foreign_key: :author_id
    has_many :likes, Svedixer.Feed.Like, foreign_key: :like_by_id
    has_many :comments, Svedixer.Feed.Comment, foreign_key: :commenter_id

    # Virtual fields:
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/, message: "Invalid email address")
    |> validate_length(:password,
      min: 8,
      message: "Password lenght should be minimum 8 charactors"
    )
    |> validate_confirmation(:password, message: "Password and Confirm Password must be same")
    |> unique_constraint(:email, message: "Email has already been taken")
    |> put_password_hash
  end

  def user_changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :email, :password_hash])
    |> validate_required([:id, :email, :password_hash])
  end

  @doc """
    encrypt password and put it into password_hash field
  """
  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        change(changeset, Bcrypt.add_hash(pass))

      _ ->
        changeset
    end
  end
end
