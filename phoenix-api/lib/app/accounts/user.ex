defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [
    :id,
    :first_name,
    :last_name,
    :birthdate,
    :gender,
    :inserted_at,
    :updated_at
  ]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :birthdate, :date
    field :gender, :string

    timestamps(type: :utc_datetime)
  end

  @required_params [:first_name, :last_name, :birthdate, :gender]
  @genders ["male", "female"]

  def changeset(user, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:gender, @genders)
    |> check_constraint(:gender, name: "gender")
  end
end
