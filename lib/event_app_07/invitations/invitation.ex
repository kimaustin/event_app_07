defmodule EventApp07.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :email, :string
    field :response, :string
    belongs_to :event, EventApp07.Events.Event
    belongs_to :user, EventApp07.Users.User

    timestamps()
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:email, :response, :event_id, :user_id])
    |> validate_required([:email, :response, :event_id])
  end
end
