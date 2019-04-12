defmodule MementhoWeb.GroupController do
  use MementhoWeb, :controller

  alias Mementho.Forums
  alias Mementho.Forums.Group

  def new(conn, _params) do
    changeset = Forums.change_group(%Group{})
    conn
    |> render("new.html", changeset: changeset, action: Routes.group_path(conn, :create))
  end

  def create(conn, %{"group" => %{"name" => name, "description" => description}}) do
    slug = create_slug(name)
    user_id = 1
    params = %{slug: slug, user_id: user_id, name: name, description: description}
    Forums.create_group(params)
    |> create_group_reply(conn)
  end

  def show(conn,%{"id" => id, "slug" => slug} = params) do
    case Forums.get_group!(id,slug) do
      {:ok, group} ->
        page = params |> Map.get("page", 0)
        posts = Forums.list_posts_by_group(id,page)
        conn
        |> render("show.html", group: group, posts: posts)
      {:error, error} -> render("error.html", error: error)
    end
  end

  defp render_show({:ok, group}, conn) do
    conn
    |> render("show.html", group: group)
  end

  defp render_show({:error, error}, conn) do
    conn
    |> render("error.html", error: error)
  end

  defp create_group_reply({:ok, group}, conn) do
    conn
    |> redirect(to: Routes.group_path(conn, :show, group.id, group.slug))
  end

  defp create_group_reply({:error, changeset}, conn) do
    conn
    |> render("new.html", changeset: changeset, action: Routes.group_path(conn, :create))
  end

  defp create_slug(name) do
    name
    |> String.trim()
    |> String.replace(" ", "-")
  end
end
