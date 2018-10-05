defmodule MementhoWeb.PageView do
  use MementhoWeb, :view
  use Timex
  def date_time_ago(date) do
    Timex.from_now(date)
  end
  def last_page(post) do
    length(post.comments) / 30
    |> Float.ceil()
    |> round()
    |> to_string()
  end
end
