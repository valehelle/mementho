defmodule Mementho.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    has_many :groups, Mementho.Forums.Group
    has_many :posts, Mementho.Forums.Post
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_format(:username, ~r/^\S*$/)
    |> unique_constraint(:email, [name: :users_email_index])
    |> unique_constraint(:username, [name: :users_username_index])
    |> put_pass_hash()
  end

defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  change(changeset, password: Bcrypt.hashpwsalt(password))
end
defp put_pass_hash(changeset), do: changeset

end
