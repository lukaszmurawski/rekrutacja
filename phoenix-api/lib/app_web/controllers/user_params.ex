defmodule AppWeb.UserParams do
  import Ecto.Changeset

  @valid_fields ~w(first_name last_name gender birthdate)a

  def cast_and_validate(params) do
    {%{}, %{first_name: :string, last_name: :string, gender: :string, birthdate: :date}}
    |> cast(params, @valid_fields)
    |> validate_required(@valid_fields)
    |> validate_inclusion(:gender, ["male", "female"])
  end
end
