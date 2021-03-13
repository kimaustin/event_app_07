defmodule EventApp07Web.InvitationController do
  use EventApp07Web, :controller

  alias EventApp07.Invitations
  alias EventApp07.Invitations.Invitation
  alias EventApp07.Users
  alias EventApp07Web.Plugs

  plug Plugs.RequireUser when action in [:show, :new, :edit, :create, :update]
  plug :fetch_invitation when action in [:show, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]

  def fetch_invitation(conn, _args) do
    id = conn.params["id"]
    invitation = Invitations.get_invitation!(id)

    # user = Users.get_user_by_email(invitation.email)

    # if user && invitation.user_id == nil do
    #   invitation.user_id = user.id
    # end

    assign(conn, :invitation, invitation)
  end

  def require_owner(conn, _args) do
    curr_user = conn.assigns[:current_user]
    invitation = conn.assigns[:invitation]

    if invitation.user_id && invitation.user_id == curr_user.id do
      conn
    else
      conn
      |> put_flash(:error, "This isn't your invitation.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    invitations = Invitations.list_invitations()
    render(conn, "index.html", invitations: invitations)
  end

  def new(conn, _params) do
    changeset = Invitations.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset, rsvp: ["yes", "no", "maybe"])
  end

  def create(conn, %{"invitation" => invitation_params}) do
    user = Users.get_user_by_email(invitation_params["email"])


    if user do
      invitation_params = invitation_params
      |> Map.put("response", "none")
      |> Map.put("user_id", user.id)

      case Invitations.create_invitation(invitation_params) do
        {:ok, invitation} ->
          conn
          |> put_flash(:info, "Invitation created successfully.")
          |> redirect(to: Routes.event_path(conn, :show, invitation.event_id))
          # add link

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:error, "An invitation requires an email.")
          |> redirect(to: Routes.event_path(conn, :show, invitation_params["event_id"]))
      end
      else
        invitation_params = invitation_params
        |> Map.put("response", "none")

        case Invitations.create_invitation(invitation_params) do
          {:ok, invitation} ->
            conn
            |> put_flash(:info, "Invitation created successfully.")
            |> redirect(to: Routes.event_path(conn, :show, invitation.event_id))
            # add link

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:error, "An invitation requires an email.")
            |> redirect(to: Routes.event_path(conn, :show, invitation_params["event_id"]))
        end
    end

    # case Invitations.create_invitation(invitation_params) do
    #   {:ok, invitation} ->
    #     conn
    #     |> put_flash(:info, "Invitation created successfully.")
    #     |> redirect(to: Routes.invitation_path(conn, :show, invitation))
    #     # add link

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    # invitation = Invitations.load_event_user(conn.assigns[:invitation])
    invitation = Invitations.get_invitation!(id)
    render(conn, "show.html", invitation: invitation)
  end

  def edit(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    changeset = Invitations.change_invitation(invitation)
    render(conn, "edit.html", invitation: invitation, changeset: changeset, rsvp: ["yes", "no", "maybe"], on_event: true)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Invitations.get_invitation!(id)

    case Invitations.update_invitation(invitation, invitation_params) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation updated successfully.")
        |> redirect(to: Routes.invitation_path(conn, :show, invitation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invitation: invitation, changeset: changeset, rsvp: ["yes", "no", "maybe"])
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    {:ok, _invitation} = Invitations.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: Routes.invitation_path(conn, :index))
  end
end
