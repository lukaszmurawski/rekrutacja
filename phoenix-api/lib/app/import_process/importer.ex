defmodule App.ImportProcess.Importer do
  alias App.Repo
  alias App.ImportProcess.UserGenerator
  require Logger # Dodano dla poprawnej obsługi Logger.error w rescue

  @fetcher Application.compile_env(:app, :data_fetcher_module)
  @max_records 100

  @spec run_import() :: {:ok, non_neg_integer} | {:error, any}
  def run_import() do
    case @fetcher.fetch_all_data(@max_records) do
      %{male: _, female: _} = initial_state ->
        users = UserGenerator.generate_users(initial_state, @max_records)

        if users == [] do
          {:error, "Brak wygenerowanych użytkowników"}
        else
          {count, _data} = Repo.insert_all(App.Accounts.User, users, on_conflict: :nothing)
          {:ok, count}
        end
      _ ->
        {:error, "Nie udało się pobrać danych źródłowych."}
    end
  rescue
    e ->
      Logger.error("Błąd podczas importu: #{inspect(e)}") # Dodano logowanie błędu
      {:error, e}
  end
end
