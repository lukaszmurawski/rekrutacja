defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :birthdate, :date, null: false
      add :gender, :string, null: false, check: "gender IN ('male', 'female')"

      timestamps(
        type: :utc_datetime,
        null: false,
        default: fragment("now()")
      )
    end
  end
end
