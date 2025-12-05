defmodule AppWeb.UserController do
  use AppWeb, :controller

  alias App.Accounts
  alias AppWeb.UserParams

  # GET /users
  def index(conn, params) do
    users = Accounts.list_users(params)
    json(conn, users)
  end

  # GET /users/:id
  def show(conn, %{"id" => id}) do
    id
    |> String.trim()
    |> Ecto.UUID.cast()
    |> case do
      {:ok, uuid} ->
        case Accounts.get_user(uuid) do
          nil -> send_resp(conn, 404, "")
          user -> json(conn, user)
        end

      :error ->
        send_resp(conn, 400, "Invalid UUID")
    end
  end

  # POST /users
  def create(conn, params) do
    case UserParams.cast_and_validate(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        case Accounts.create_user(changeset.changes) do
          {:ok, user} -> json(conn, user)
          {:error, cs} -> conn |> put_status(422) |> json(%{errors: cs})
        end

      changeset ->
        conn |> put_status(400) |> json(%{errors: changeset})
    end
  end

  # PUT /users/:id
  def update(conn, %{"id" => id} = params) do
    id
    |> String.trim()
    |> Ecto.UUID.cast()
    |> case do
      {:ok, uuid} ->
        case Accounts.get_user(uuid) do
          nil ->
            send_resp(conn, 404, "")

          _user ->
            case UserParams.cast_and_validate(params) do
              %Ecto.Changeset{valid?: true} = changeset ->
                case Accounts.update_user(uuid, changeset.changes) do
                  {:ok, user} -> json(conn, user)
                  {:error, cs} -> conn |> put_status(422) |> json(%{errors: cs})
                end

              changeset ->
                conn |> put_status(400) |> json(%{errors: changeset})
            end
        end

      :error ->
        send_resp(conn, 400, "Invalid UUID")
    end
  end

  # DELETE /users/:id
  def delete(conn, %{"id" => id}) do
    id
    |> String.trim()
    |> Ecto.UUID.cast()
    |> case do
      {:ok, uuid} ->
        case Accounts.get_user(uuid) do
          nil ->
            send_resp(conn, 404, "")

          _user ->
            Accounts.delete_user(uuid)
            send_resp(conn, 204, "")
        end

      :error ->
        send_resp(conn, 400, "Invalid UUID")
    end
  end
end
