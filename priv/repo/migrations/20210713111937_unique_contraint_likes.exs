defmodule Svedixer.Repo.Migrations.UniqueContraintLikes do
  use Ecto.Migration

  def change do
    create unique_index(:likes, [:like_by_id, :like_to_id], name: :unique_contraint_likes)
  end
end
