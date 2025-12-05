defmodule App.External.PeselDataFetcher do
  @moduledoc "Pobiera dane z dane.gov.pl i zwraca listy imion/nazwisk."
  @behaviour App.External.DataFetcherBehaviour

  require Logger

  @timeout 30_000

  @impl true
  def fetch_all_data(limit) when is_integer(limit) and limit > 0 do
    config = get_config()

    unless Enum.all?(Map.values(config), & &1) do
      Logger.error("Brak zmiennych środowiskowych URL dla importu PESEL.")
      raise "Missing configuration for PESEL import URLs."
    end

    with {:ok, male_names} <- fetch_and_parse(config.male_names, limit),
         {:ok, male_surnames} <- fetch_and_parse(config.male_surnames, limit),
         {:ok, female_names} <- fetch_and_parse(config.female_names, limit),
         {:ok, female_surnames} <- fetch_and_parse(config.female_surnames, limit) do

      %{
        male: %{names: Enum.shuffle(male_names), surnames: Enum.shuffle(male_surnames)},
        female: %{names: Enum.shuffle(female_names), surnames: Enum.shuffle(female_surnames)}
      }
    else
      {:error, reason} ->
        Logger.error("Błąd podczas pobierania danych: #{reason}")
        raise "Nie można załadować wszystkich danych importu."
    end
  end

  defp get_config() do
    %{
      male_names: System.get_env("MALE_NAMES_URL"),
      male_surnames: System.get_env("MALE_SURNAMES_URL"),
      female_names: System.get_env("FEMALE_NAMES_URL"),
      female_surnames: System.get_env("FEMALE_SURNAMES_URL")
    }
  end

  # Pobranie i sparsowanie CSV
  defp fetch_and_parse(url, limit) do
    case HTTPoison.get(url, [], timeout: @timeout) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, io_device} = StringIO.open(body)

        data =
          io_device
          |> IO.stream(:line)
          |> CSV.decode(separator: ?,)
          |> Stream.drop(1) # pomijamy nagłówek
          |> Stream.map(fn
            {:ok, row} -> hd(row)
            {:error, _} -> nil
          end)
          |> Stream.filter(& &1)
          |> Enum.take(limit)

        if data == [] do
          {:error, "Brak danych do zaimportowania"}
        else
          {:ok, data}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Błąd HTTP: #{code}"}

      {:error, reason} ->
        {:error, "Błąd HTTPoison: #{inspect(reason)}"}
    end
  end
end
