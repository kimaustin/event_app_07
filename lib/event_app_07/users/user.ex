defmodule EventApp07.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :events, EventApp07.Events.Event
    has_many :comments, EventApp07.Comments.Comment
    has_many :invitations, EventApp07.Invitations.Invitation

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
