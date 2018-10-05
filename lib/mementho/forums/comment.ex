defmodule Mementho.Forums.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :content, :string

    belongs_to :reply, Mementho.Forums.Comment
    has_many :replies, Mementho.Forums.Comment, foreign_key: :reply_id
    belongs_to :user, Mementho.Accounts.User
    belongs_to :post, Mementho.Forums.Post
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :reply_id, :post_id, :user_id])
    |> validate_required([:content, :user_id])
  end
end
