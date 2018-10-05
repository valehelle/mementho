defmodule Mementho.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :reply_id, references(:comments, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:post_id])
    create index(:comments, [:user_id])
    create index(:comments, [:reply_id])
  end
end
