defmodule Mementho.Forums.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :name, :string
    field :slug, :string
    field :is_live, :boolean
    field :last_date, :utc_datetime, default: Ecto.DateTime.utc
    belongs_to :user, Mementho.Accounts.User
    belongs_to :group, Mementho.Forums.Group
    has_many :comments, Mementho.Forums.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, [:name, :group_id, :slug, :user_id, :is_live, :last_date])
    |> cast_assoc(:comments, required: true)
    |> foreign_key_constraint(:group_id)
    |> validate_required([:name, :group_id, :slug, :user_id, :is_live])
  end
end
