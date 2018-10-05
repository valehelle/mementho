defmodule Mementho.Forums.Group do
  use Ecto.Schema
  import Ecto.Changeset


  schema "groups" do
    field :name, :string
    field :slug, :string
    field :description, :string

    belongs_to :user, Mementho.Accounts.User
    has_many :posts, Mementho.Forums.Post

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :slug, :user_id, :description])
    |> validate_required([:name, :slug, :user_id, :description])
  end
end
