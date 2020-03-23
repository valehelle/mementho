defmodule MementhoWeb.PageController do
  use MementhoWeb, :controller
  alias Mementho.Forums
  alias Mementho.Accounts
  alias Mementho.Accounts.User
  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    conn
    |> render("index.html", changeset: changeset, action: Routes.user_path(conn, :register_user))
  end
end
