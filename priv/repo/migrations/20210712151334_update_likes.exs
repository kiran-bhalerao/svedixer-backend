defmodule Svedixer.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :like_to_id, references(:posts, on_delete: :nothing, type: :binary_id)
      add :like_by_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:likes, [:like_to_id])
    create index(:likes, [:like_by_id])
  end
end
