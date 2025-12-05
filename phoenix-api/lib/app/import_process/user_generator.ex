defmodule App.ImportProcess.UserGenerator do
  @moduledoc """
  Generuje listę map użytkowników na podstawie wczytanych danych.
  Liczba użytkowników podawana jako parametr.
  Powtarzanie imion i nazwisk jest dozwolone.
  """

  @spec generate_users(map(), pos_integer()) :: list(map())
  def generate_users(initial_state, count)
      when is_map(initial_state) and is_integer(count) and count > 0 do
    Enum.map(1..count, fn _ -> build_random_user(initial_state) end)
  end

  # Buduje losowego użytkownika
  defp build_random_user(state) do
    gender_key = Enum.random([:male, :female])
    gender = atom_to_gender(gender_key)

    names = state[gender_key][:names]
    surnames = state[gender_key][:surnames]

    # Losujemy imię i nazwisko niezależnie, mogą się powtarzać
    first_name = Enum.random(names)
    last_name = Enum.random(surnames)

    start_date = ~D[1970-01-01]
    end_date = ~D[2024-12-31]
    random_days = :rand.uniform(Date.diff(end_date, start_date))
    birthdate = Date.add(start_date, random_days)

    %{
      first_name: first_name,
      last_name: last_name,
      birthdate: birthdate,
      gender: gender
    }
  end

  # Atom → string
  defp atom_to_gender(:male), do: "male"
  defp atom_to_gender(:female), do: "female"
end
