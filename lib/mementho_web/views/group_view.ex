defmodule MementhoWeb.GroupView do
  use MementhoWeb, :view
  import Scrivener.HTML
  use Timex

  def date_time_ago(date) do
    Timex.from_now(date)
  end

  def thread_or_chat(post) do
    case post.is_live do
      true -> "Chat"
      false -> "Thread"
    end
  end

  def last_page(post) do
    length(post.comments) / 30
    |> Float.ceil()
    |> round()
    |> to_string()
  end

  def comment_text(post) do
    length(post.comments)
    |> to_string()
    |> join_string("comments")
  end

  defp join_string(str1, str2) do
    str1 <> " " <> str2
  end
end