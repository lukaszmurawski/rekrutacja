defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :birthdate, :date
      add :gender, :string, null: false, check: "gender IN ('male', 'female')"

      timestamps(type: :utc_datetime)
    end
  end
end
