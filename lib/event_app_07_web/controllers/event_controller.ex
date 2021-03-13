defmodule EventApp07Web.EventController do
  use EventApp07Web, :controller

  alias EventApp07.Events
  alias EventApp07.Events.Event
  alias EventApp07.Comments
  alias EventApp07.Invitations
  alias EventApp07.Photos
  alias EventApp07Web.Plugs

  plug Plugs.RequireUser when action in [:new, :edit, :create, :update]
  plug :fetch_event when action in [:show, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]

  def fetch_event(conn, _args) do
    id = conn.params["id"]
    event = Events.get_event!(id)
    assign(conn, :event, event)
  end
  def require_owner(conn, _args) do
    user = conn.assigns[:current_user]
    event = conn.assigns[:event]

    if user.id == event.user_id do
      conn
    else
      conn
      |> put_flash(:error, "That isn't yours.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end
  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"event" => event_params}) do
    up = event_params["photo"]
    {:ok, hash} = Photos.save_photo(up.filename, up.path)

    event_params = event_params
    |> Map.put("user_id", conn.assigns[:current_user].id)
    |> Map.put("photo_hash", hash)

    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => _id}) do
    event = Events.load_comments_invitations(conn.assigns[:event])
    num_yes = Enum.count(event.invitations, fn x -> x.response == "yes" end)
    num_no = Enum.count(event.invitations, fn x -> x.response == "no" end)
    num_maybe = Enum.count(event.invitations, fn x -> x.response == "maybe" end)
    num_none = Enum.count(event.invitations, fn x -> x.response == "none" || x.response == "" end)
    # event = Events.get_event!(id)
    comm = %Comments.Comment{
      event_id: event.id,
      user_id: current_user_id(conn),
      vote: 0,
    }
    invitation = %Invitations.Invitation{
      event_id: event.id,
      email: "",
      response: "none"
    }
    new_comment = Comments.change_comment(comm)
    new_invitation = Invitations.change_invitation(invitation)
    render(conn, "show.html", event: event, new_comment: new_comment, new_invitation: new_invitation,
      num_yes: num_yes, num_no: num_no, num_maybe: num_maybe, num_none: num_none)
  end

  def edit(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    # event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    # event = conn.assigns[:event]
    # event = Events.get_event!(id)
    event = Events.get_event!(id)
    up = event_params["photo"]

    event_params = if up do
      # FIXME: Remove old image
      {:ok, hash} = Photos.save_photo(up.filename, up.path)
      Map.put(event_params, "photo_hash", hash)
    else
      event_params
    end

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    event = conn.assigns[:event]
    # event = Events.get_event!(id)

    # FIXME: Remove old image
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end

  # New controller function.
  def photo(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _name, data} = Photos.load_photo(event.photo_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

end
