defmodule Svedixer.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :string
      add :published, :boolean, default: false, null: false
      add :author_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:posts, [:author_id])
  end
end
