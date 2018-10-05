defmodule MementhoWeb.PageController do
  use MementhoWeb, :controller
  alias Mementho.Forums
  alias Mementho.Accounts
  alias Mementho.Accounts.User
  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    posts = Forums.list_latest_posts(1,2)
    groups = Forums.list_groups()
    conn
    |> render("index.html", changeset: changeset, action: user_path(conn, :register_user), posts: posts, groups: groups)
  end
end
