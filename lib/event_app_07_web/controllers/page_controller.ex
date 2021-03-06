defmodule EventApp07Web.PageController do
  use EventApp07Web, :controller

  alias EventApp07.Events
  alias EventApp07.Invitations

  def index(conn, _params) do
    # render(conn, "index.html")
    # events = Events.list_events()
    if have_current_user?(conn) do
      events = Events.list_events_for_user(conn.assigns[:current_user].id)
      invitations = Invitations.list_invitations_for_user(conn.assigns[:current_user].id)
      render(conn, "index.html", events: events, invitations: invitations)
      else
        events = []
        render(conn, "index.html", events: events)
    end
  end
end
