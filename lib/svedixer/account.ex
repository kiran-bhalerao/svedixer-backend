defmodule Svedixer.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Svedixer.Repo

  alias Svedixer.Account.User
  alias Svedixer.Guardian

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)

      err ->
        err
    end
  end

  @doc """
  Returns user by email
  """
  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "Login error."}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id) |> Repo.preload(:posts)

    # query =
    #   from u in Svedixer.Account.User,
    #     where: u.id == ^id,
    #     join: p in Svedixer.Feed.Post,
    #     on: p.author_id == u.id,
    #     preload: [:posts]

    # Repo.one(query)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  ###### private functions #########
  defp verify_password(password, %User{} = user) do
    case Bcrypt.check_pass(user, password) do
      {:ok, user} ->
        {:ok, user}

      err ->
        err
    end
  end

  defp email_password_auth(email, password) do
    with {:ok, user} <- get_by_email(email), do: verify_password(password, user)
  end
end
