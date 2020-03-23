defmodule Mementho.Forums.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :name, :string
    field :slug, :string
    field :is_live, :boolean
    field :last_date, :utc_datetime, default: DateTime.utc_now()
    has_many :comments, Mementho.Forums.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, [:name,:slug,  :is_live, :last_date])
    |> cast_assoc(:comments, required: false)
    |> validate_required([:name, :slug, :is_live])
  end
end
