defmodule EventApp07.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date, :string
    field :desc, :string
    field :title, :string
    belongs_to :user, EventApp07.Users.User
    has_many :comments, EventApp07.Comments.Comment
    has_many :invitations, EventApp07.Invitations.Invitation

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :date, :desc, :user_id])
    |> validate_required([:title, :date, :desc, :user_id])
  end
end
