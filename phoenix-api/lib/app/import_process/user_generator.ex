defmodule App.ImportProcess.UserGenerator do
  @moduledoc """
  Generuje listę map użytkowników na podstawie wczytanych danych.
  Liczba użytkowników podawana jako parametr.
  """

  @spec generate_users(map(), pos_integer()) :: list(map())
  def generate_users(initial_state, count) when is_map(initial_state) and is_integer(count) and count > 0 do
    {users, _state} = generate_users_recursively(initial_state, [], count)

    # gwarancja — zwracamy dokładnie tyle, ile poproszono (lub mniej, jeśli zabrakło danych)
    Enum.take(users, count)
  end

  # Rekurencja oparta na liczniku remaining_count
  defp generate_users_recursively(state, acc, remaining_count) do
    cond do
      remaining_count <= 0 ->
        {Enum.reverse(acc), state}

      exhausted?(state) ->
        # Brak jakichkolwiek danych
        {Enum.reverse(acc), state}

      true ->
        gender_key = Enum.random([:male, :female])

        case get_user_data(state, gender_key) do
          {:ok, data, new_state} ->
            user = build_user(data)
            generate_users_recursively(new_state, [user | acc], remaining_count - 1)

          :empty ->
            # spróbuj drugiej płci
            alt_key = if gender_key == :male, do: :female, else: :male

            case get_user_data(state, alt_key) do
              {:ok, data, new_state} ->
                user = build_user(data)
                generate_users_recursively(new_state, [user | acc], remaining_count - 1)

              :empty ->
                # zabrakło danych dla obu — kończymy
                {Enum.reverse(acc), state}
            end
        end
    end
  end

  # Czy stan jest całkowicie wyczerpany?
  defp exhausted?(state) do
    Enum.all?(state, fn {_gender, %{names: names, surnames: surnames}} ->
      names == [] or surnames == []
    end)
  end

  # Pobiera i zdejmuje (shift) imię i nazwisko
  defp get_user_data(state, gender_key) do
    case state[gender_key] do
      %{names: [name | rest_names], surnames: [surname | rest_surnames]} ->
        new_state =
          Map.put(state, gender_key, %{
            names: rest_names,
            surnames: rest_surnames
          })

        {:ok, %{name: name, surname: surname, gender: atom_to_gender(gender_key)}, new_state}

      _ ->
        :empty
    end
  end

  # Atom → string
  defp atom_to_gender(:male), do: "male"
  defp atom_to_gender(:female), do: "female"

  # Buduje mapę użytkownika
  defp build_user(%{name: first_name, surname: last_name, gender: gender}) do
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
end
