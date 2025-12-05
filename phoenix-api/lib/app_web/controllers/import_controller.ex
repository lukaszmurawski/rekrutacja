defmodule AppWeb.ImportController do
  use AppWeb, :controller

  # Delegujemy wywołanie do modułu Orchestratora
  alias App.ImportProcess.Importer

  @doc "Obsługuje żądanie POST /import i uruchamia proces generowania użytkowników."
  def import(conn, _params) do
    case Importer.run_import() do
      {:ok, count} ->
        # Sukces: zwracamy status 201 Created i informację o liczbie dodanych rekordów
        conn
        |> put_status(:created)
        |> json(%{
          message: "Import użytkowników zakończony sukcesem.",
          records_created: count
        })

      {:error, reason} ->
        # Błąd: zwracamy status 500 Internal Server Error
        # Pamiętaj, aby logować błędy w Importerze/Fetcherze!
        conn
        |> put_status(:internal_server_error)
        |> json(%{
          error: "Wystąpił błąd podczas importu.",
          details: inspect(reason)
        })
    end
  end
end
