defmodule EventApp07.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :email, :string, null: false
      add :response, :string, null: false
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing), null: true
      # add :link, :string, null: false

      timestamps()
    end

    create index(:invitations, [:event_id])
    create index(:invitations, [:user_id])
  end
end
