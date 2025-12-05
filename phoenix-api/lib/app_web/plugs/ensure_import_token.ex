defmodule AppWeb.Plugs.EnsureImportToken do
  import Plug.Conn

  @header_name "x-import-token"

  def init(default), do: default

  def call(conn, _opts) do
    expected_token = System.get_env("IMPORT_API_TOKEN")

    case get_req_header(conn, @header_name) do
      [^expected_token] -> conn
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end
end
