defmodule Mementho.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :name, :string
      add :slug, :string
      add :last_date, :utc_datetime
      add :is_live, :boolean, default: "false"
      add :user_id, references(:users, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps()
    end

    create index(:posts, [:user_id])
    create index(:posts, [:group_id])
  end
end
