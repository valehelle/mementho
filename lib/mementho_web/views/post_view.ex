defmodule MementhoWeb.PostView do
  use MementhoWeb, :view
  import Scrivener.HTML
  use Timex
  def date_time_ago(date) do
    Timex.from_now(date)
  end

  def generateHtml(text) do
    text
    |> text_to_html(wrapper_tag: :div)
    |> safe_to_string
    |> String.replace(~r/https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-z]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*/, "<a href =\\0> \\0 </a>") 
    |> String.replace(~r/\*\*.*\*\*/,"<b>\\0</b>")
    |> String.replace(~r/\*\*/,"")
    |> text_to_html([attributes: [style: "color:black;  font-size:12pt; margin-bottom: 2px;"],escape: false, wrapper_tag: :div])
  end
  defp printString(lelo) do
    require Logger
    Logger.info lelo
    lelo
  end

end

