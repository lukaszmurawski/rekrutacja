defmodule App.External.DataFetcherBehaviour do
  @moduledoc "Kontrakt dla modułów dostarczających dane PESEL."

  @callback fetch_all_data(limit :: pos_integer()) :: %{
    male: %{names: list(String.t()), surnames: list(String.t())},
    female: %{names: list(String.t()), surnames: list(String.t())}
  }
end
