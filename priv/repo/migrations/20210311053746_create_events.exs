defmodule EventApp07.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :text, null: false
      add :date, :text, null: false
      add :desc, :text, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

  end
end
