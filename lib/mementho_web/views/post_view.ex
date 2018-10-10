defmodule MementhoWeb.PostView do
  use MementhoWeb, :view
  import Scrivener.HTML
  use Timex
  def date_time_ago(date) do
    Timex.from_now(date)
  end

  def generateHtml(text) do
    text
    |> text_to_html()
    |> safe_to_string
    |> String.replace(~r/https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*/, "<a href =\\0> \\0 </a>")
    |> text_to_html([attributes: [style: "color:black;  margin-top: 10px; font-size:11pt; margin-bottom: 2px; line-height: 19px;"],escape: false])
  end

end
