defmodule EventApp07Web.PageController do
  use EventApp07Web, :controller

  alias EventApp07.Events

  def index(conn, _params) do
    # render(conn, "index.html")
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end
end
