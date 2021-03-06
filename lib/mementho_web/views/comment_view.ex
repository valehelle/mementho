defmodule MementhoWeb.CommentView do
  use MementhoWeb, :view
  def generateHtml(text) do
    text
    |> text_to_html(wrapper_tag: :div)
    |> safe_to_string
    |> String.replace(~r/https?:\/\/[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-z]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*/, "<a href =\\0> \\0 </a>") 
    |> String.replace(~r/\*\*[\s\S]+\*\*/,"<b>\\0</b>")
    |> String.replace(~r/\*\*/,"")
    |> text_to_html([attributes: [style: "color:black;  font-size:12pt; margin-bottom: 2px;"],escape: false, wrapper_tag: :div])
  end
end