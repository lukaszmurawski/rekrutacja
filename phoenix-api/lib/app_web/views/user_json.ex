defmodule AppWeb.UserJSON do
  def index(%{users: users}) do
    %{data: Enum.map(users, &data/1)}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      gender: user.gender,
      birthdate: user.birthdate,
      inserted_at: user.inserted_at
    }
  end
end
