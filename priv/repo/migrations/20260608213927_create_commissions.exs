defmodule Todo.Repo.Migrations.CreateCommissions do
  use Ecto.Migration

  def change do
    create table(:commissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :customer, :string
      add :type, :string
      add :status, :string
      add :notes, :text
      add :deadline, :utc_datetime

      timestamps()
    end
  end
end
