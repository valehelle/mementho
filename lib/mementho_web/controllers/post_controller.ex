defmodule MementhoWeb.PostController do
  use MementhoWeb, :controller

  alias Mementho.Forums.Comment
  alias Mementho.Forums
  alias Mementho.Forums.Post
  alias Mementho.Accounts

  def new(conn, %{"group_id" => group_id, "slug" => slug}) do
    changeset = Forums.change_post(%Post{})
    user = Guardian.Plug.current_resource(conn)
    case Forums.get_group!(group_id,slug) do
      {:ok, group} -> 
        conn
        |> render("new.html", changeset: changeset, action: Routes.post_path(conn, :create, group.id, group.slug), group: group, user: user)
      {:error, error} -> render(conn, "error.html", error: error)
    end 

  end

  def new_live(conn, %{"group_id" => group_id, "slug" => slug}) do
    changeset = Forums.change_post(%Post{})
    user = Guardian.Plug.current_resource(conn)
    case Forums.get_group!(group_id,slug) do
      {:ok, group} -> 
        conn
        |> render("new_live.html", changeset: changeset, action: Routes.post_path(conn, :create_live, group_id, slug), group: group, user: user)
      {:error, error} -> render(conn, "error.html", error: error)
    end 
    
  end

  def create(conn, %{"group_id" => group_id, "slug" => slug,"post" => %{"name" => name, "comments" => %{"0" => %{"content" => content}}} = params }) do
    user = Guardian.Plug.current_resource(conn)
    case Map.get(params,"username", nil) do
      nil -> 
        case Forums.get_group!(group_id,slug) do
          {:ok, group} -> 
            post_slug = create_slug(name)
            params = %{user_id: user.id, name: name, group_id: group_id, slug: post_slug, is_live: false, comments: [%{content: content, user_id: user.id}], last_date: DateTime.utc_now}
            Forums.create_post_comment(params)
            |> create_post_respond(conn, group_id, slug)
          {:error, error} -> render(conn, "error.html", error: error)
        end
      username -> 
        if(user.email === "hazmiirfan92@gmail.com") do
          {:ok, new_user} = Accounts.find_or_create_user(username)
          post_slug = create_slug(name)
          params = %{user_id: new_user.id, name: name, group_id: group_id, slug: post_slug, is_live: false, comments: [%{content: content, user_id: new_user.id}], last_date: DateTime.utc_now}
          Forums.create_post_comment(params)
          |> create_post_respond(conn, group_id, slug)
        else
          render(conn, "error.html", error: "undefined")
        end
    end

  end

  def create_live(conn, %{"group_id" => group_id, "slug" => slug,"post" => %{"name" => name, "comments" => %{"0" => %{"content" => content}}} = params}) do
    user = Guardian.Plug.current_resource(conn)
    case Map.get(params,"username", nil) do
      nil -> 
        case Forums.get_group!(group_id,slug) do
          {:ok, group} -> 
            post_slug = create_slug(name)
            params = %{user_id: user.id, name: name, group_id: group_id, slug: post_slug, is_live: true, comments: [%{content: content, user_id: user.id}], last_date: DateTime.utc_now}
            Forums.create_post_comment(params)
            |> create_post_respond(conn, group_id, slug)
          {:error, error} -> render(conn, "error.html", error: error)
        end
      username -> 
        if(user.email === "hazmiirfan92@gmail.com") do
          {:ok, new_user} = Accounts.find_or_create_user(username)
          post_slug = create_slug(name)
          params = %{user_id: new_user.id, name: name, group_id: group_id, slug: post_slug, is_live: true, comments: [%{content: content, user_id: new_user.id}], last_date: DateTime.utc_now}
          Forums.create_post_comment(params)
          |> create_post_respond(conn, group_id, slug)
        else
          render(conn, "error.html", error: "undefined")
        end
    end

  end

  def show(conn,%{"post_id" => post_id, "post_slug" => post_slug}  = params ) do
    case Forums.get_post!(post_id,post_slug) do
      {:ok, post} -> 
        page = params |> Map.get("page", 0)
        Mementho.Forums.list_paginate_comments(post.id,page,30)
        |> render_show(conn, post) 
      {:error, error} -> nil
    end
  end

  def show_live(conn,%{"post_id" => post_id, "post_slug" => post_slug}) do
    user = Guardian.Plug.current_resource(conn)
    Forums.get_post_comments!(post_id,post_slug)
    |> render_show_live(conn,user)
  end

  defp render_show_live(post, conn, user) do
    conn
    |> render("show_live.html", post: post, user: user)
  end

  defp render_show_live({:error, error}, conn, user) do
    conn
    |> render("error.html", error: error, user: user)
  end


  defp render_show(comments, conn, post) do
    changeset = Forums.change_comment(%Comment{})
    user = Guardian.Plug.current_resource(conn)
    conn
    |> render("show.html", changeset: changeset, action: Routes.comment_path(conn, :create, post.id, post.slug), post: post, comments: comments, user: user)
  end

  defp render_show({:error, error}, conn, post) do
    conn
    |> render("error.html", error: error)
  end

  defp create_post_respond({:ok, post}, conn, group_id, slug) do
    case post.is_live do
      true -> redirect(conn, to: Routes.post_path(conn, :show_live, post.id, post.slug))
      false -> redirect(conn, to: Routes.post_path(conn, :show, post.id, post.slug))
    end
  end

  defp create_post_respond({:error, changeset}, conn, group_id, slug) do
    conn
    |> render("new.html", changeset: changeset, action: Routes.post_path(conn,:create, group_id, slug))
  end

  defp create_slug(name) do
    name
    |> String.trim()
    |> String.replace(":", "-")
    |> String.replace(" ", "-")
  end

  def delete(conn, %{"group_id" => group_id, "group_slug" => group_slug, "post_id" => post_id, "post_slug" => post_slug}) do
    Guardian.Plug.current_resource(conn)
    |> Mementho.Forums.delete_post_id_slug(post_id, post_slug)
    redirect(conn, to: Routes.group_path(conn, :show, group_id, group_slug))
  end

  def twitter_url(conn, %{"url" => url}) do
  require Logger
    case HTTPoison.get("https://publish.twitter.com/oembed?url=" <> url) do
    {:ok, %{status_code: 200, body: body}} ->
      resp = Poison.decode!(body)
      json conn, resp
    end

  end
  def fabric(conn, params) do
  require Logger
  Logger.info params
  end

end
