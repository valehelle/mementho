defmodule MementhoWeb.UserChannel do
  use Phoenix.Channel
  use Timex
  def join("user:" <> params, _params, socket) do
    {:ok, socket}
  end
  def handle_in("fetch_message", %{"post_id" => post_id, "post_slug" => post_slug}, socket) do
    case Mementho.Forums.get_post!(post_id,post_slug) do
      {:ok, post} -> 
        comments = Mementho.Forums.list_latest_comments(post.id)
        reverse_comments = Enum.reverse(comments)
        Enum.each reverse_comments, fn comment -> 
            broadcast! socket, "new_msg", %{inserted_at: date_time_ago(comment.inserted_at), user: comment.user.username, content: comment.content}
        end
      {:error, error} -> nil
    end
    {:noreply, socket}
  end


  defp date_time_ago(date) do
    Timex.from_now(date)
  end
end