defmodule MementhoWeb.CommentController do
  use MementhoWeb, :controller

  alias Mementho.Forums
  alias Mementho.Forums.Comment
  alias Mementho.Accounts

  def new(conn, %{"post_slug" => post_slug, "post_id" => post_id}) do
    case Forums.get_post!(post_id,post_slug) do
      {:ok, post} ->
        user = Guardian.Plug.current_resource(conn)
        changeset = Forums.change_comment(%Comment{})
        conn
        |> render("new.html", changeset: changeset, action: comment_path(conn, :create, post.id, post.slug), post: post, user: user)
      {:error, error} -> render(conn, "error.html", error: error)
    end
  end

  def create(conn, %{"post_id" => post_id, "post_slug" => post_slug, "comment" => %{"content" => content} = params}) do
    user = Guardian.Plug.current_resource(conn)
    case Map.get(params,"name", nil) do
      nil -> 
        case Forums.get_post!(post_id,post_slug) do
          {:ok, post} -> 
            params = %{post_id: post_id, content: content, post_slug: post_slug, user_id: user.id}
            Forums.create_comment(params)
            |> create_comment_respond(conn, post_id, post_slug, user.username)
          {:error, error} -> render(conn, "error.html", error: error)
        end
      name -> 
        if(user.email === "hazmiirfan92@gmail.com") do
          {:ok, new_user} = Accounts.find_or_create_user(name)
          params = %{post_id: post_id, content: content, post_slug: post_slug, user_id: new_user.id}
          Forums.create_comment(params)
          |> create_comment_respond(conn, post_id, post_slug, new_user.username)
        else
          render(conn, "error.html", error: "undefined")
        end
    end

  end

  defp create_comment_respond({:ok, comment}, conn, post_id, post_slug, username) do
    topic = Enum.join(["room", post_id, post_slug], ":")
    MementhoWeb.Endpoint.broadcast(topic, "new_msg", %{user: username, content: comment.content})
    post = Forums.get_post_comments!(post_id,post_slug)
    Mementho.Forums.update_post(post, %{last_date: comment.inserted_at})
    conn
    |> redirect(to: post_path(conn, :show, post_id, post_slug, page: last_page(post)))
  end

  defp create_comment_respond({:error, changeset}, conn, post_id, post_slug, username) do
    post = Forums.get_post_comments!(post_id,post_slug)
    conn
    |> render("new.html", changeset: changeset, action: comment_path(conn,:create, post_id, post_slug), post: post)
  end


  defp last_page(post) do
    length(post.comments) / 30
    |> Float.ceil()
    |> round()
    |> to_string()
  end


  def reply_new(conn, %{"post_slug" => post_slug, "post_id" => post_id, "comment_id" => comment_id}) do

    case Forums.get_post!(post_id,post_slug) do
      {:ok, post} -> 
        changeset = Forums.change_comment(%Comment{})
        case Forums.get_comment!(post_id, post_slug, comment_id) do
          {:ok, comment} -> 
            conn
            |> render("reply_new.html", changeset: changeset, action: comment_path(conn, :reply_create, post.id, post.slug, comment_id), post: post, comment: comment)
          {:error, error} -> render(conn, "error.html", error: error)
        end
     
      {:error, error} -> render(conn, "error.html", error: error)
    end
  end

  def reply_create(conn, %{"post_id" => post_id, "post_slug" => post_slug, "comment_id" => comment_id, "comment" => %{"content" => content}}) do
    user = Guardian.Plug.current_resource(conn)
    case Forums.get_comment!(post_id, post_slug, comment_id) do
      {:ok, comment} -> 
        params = %{post_id: post_id, content: content, post_slug: post_slug, reply_id: comment.id, user_id: user.id}
        Forums.create_comment(params)
        |> create_reply_comment_respond(conn,post_id,post_slug, comment_id, user.username)
      {:error, error} -> render(conn, "error.html", error: error)
    end
  end

  defp create_reply_comment_respond({:ok, comment}, conn, post_id, post_slug, comment_id, username) do
    topic = Enum.join(["room", post_id, post_slug], ":")
    MementhoWeb.Endpoint.broadcast(topic, "new_msg", %{user: username, content: comment.content})

    post = Forums.get_post_comments!(post_id,post_slug)
    Mementho.Forums.update_post(post, %{last_date: comment.inserted_at})
    conn
    |> redirect(to: post_path(conn, :show, post_id, post_slug, page: last_page(post)))
  end

  defp create_reply_comment_respond({:error, changeset}, conn, post_id, post_slug, comment_id) do
    conn
    |> render("new.html", changeset: changeset, action: comment_path(conn,:reply_create, post_id, post_slug, comment_id))
  end
end
