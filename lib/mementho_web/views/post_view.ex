defmodule MementhoWeb.PostView do
  use MementhoWeb, :view
  import Scrivener.HTML
  use Timex
  def date_time_ago(date) do
    Timex.from_now(date)
  end

end
