defmodule MementhoWeb.PageController do
  use MementhoWeb, :controller
  alias Mementho.Forums
  alias Mementho.Accounts
  alias Mementho.Accounts.User
  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    IO.inspect  Guardian.Plug.current_resource(conn)
    case Guardian.Plug.current_resource(conn) do
      nil ->  
        conn
        |> render("index.html", changeset: changeset, action: Routes.user_path(conn, :register_user))
      user -> redirect(conn, to: "/location")

    end
  end
end
