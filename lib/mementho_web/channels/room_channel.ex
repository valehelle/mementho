defmodule MementhoWeb.RoomChannel do
  use Phoenix.Channel
  use Timex
  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> params, _params, socket) do
    s = String.split(params, ":")
    post_id = Enum.at(s, 0)
    post_slug = Enum.at(s, 1)
    case Mementho.Forums.get_post!(post_id,post_slug) do
      {:ok, post} -> {:ok, socket}
      {:error,error} -> {:noreply, socket}
    end
  end
  def handle_in("new_msg", %{"body" => body}, socket) do
    s = String.split(socket.topic, ":")
    post_id = Enum.at(s, 1)
    post_slug = Enum.at(s, 2)
    case Guardian.Phoenix.Socket.authenticated?(socket) do 
      true ->  
        user = Guardian.Phoenix.Socket.current_resource(socket)
        case Mementho.Forums.get_post!(post_id,post_slug) do
          {:ok, post} -> 
            params = %{post_id: post_id, content: body, post_slug: post_slug, user_id: user.id}
            case Mementho.Forums.create_comment(params) do
              {:ok, comment} ->
                post = Mementho.Forums.get_post_comments!(post_id,post_slug)
                Mementho.Forums.update_post(post, %{last_date: comment.inserted_at})
                broadcast! socket, "new_msg", %{inserted_at: date_time_ago(comment.inserted_at), user: user.username, content: comment.content}
              {:error,error} -> {:ok, socket}
            end
        end
      false -> {:noreply, socket}
    end
    {:noreply, socket}
  end


  defp date_time_ago(date) do
    Timex.from_now(date)
  end
end