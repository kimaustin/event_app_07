defmodule EventApp07.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :vote, :integer
    belongs_to :event, EventApp07.Events.Event
    belongs_to :user, EventApp07.Users.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :vote, :event_id, :user_id])
    |> validate_required([:body, :event_id, :user_id])
  end
end
