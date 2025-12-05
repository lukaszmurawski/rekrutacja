defmodule App.Accounts do
  import Ecto.Query
  alias App.Repo
  alias App.Accounts.User

  # -------------------------
  # GET /users (lista)
  # -------------------------
  def list_users(params \\ %{}) do
    User
    |> filter(params)
    |> sort(params)
    |> Repo.all()
  end

  # -------------------------
  # Filtrowanie
  # -------------------------
  @allowed_string_fields ~w(first_name last_name gender)a

  defp filter(query, params) do
    query
    |> filter_string(:first_name, params["first_name"])
    |> filter_string(:last_name, params["last_name"])
    |> filter_string(:gender, params["gender"])
    |> filter_date_from(params["birthdate_from"])
    |> filter_date_to(params["birthdate_to"])
  end

  # --- filtr tekstowy ---
  defp filter_string(query, _field, nil), do: query
  defp filter_string(query, _field, ""), do: query

  defp filter_string(query, field, value) when field in @allowed_string_fields do
    where(query, [u], field(u, ^field) == ^value)
  end

  defp filter_string(query, _field, _value),
    do: query   # ignoruje nieznane pola (bez błędów)

  # --- data od ---
  defp filter_date_from(query, nil), do: query
  defp filter_date_from(query, ""), do: query
  defp filter_date_from(query, value) do
    {:ok, date} = Date.from_iso8601(value)
    where(query, [u], u.birthdate >= ^date)
  end

  # --- data do ---
  defp filter_date_to(query, nil), do: query
  defp filter_date_to(query, ""), do: query
  defp filter_date_to(query, value) do
    {:ok, date} = Date.from_iso8601(value)
    where(query, [u], u.birthdate <= ^date)
  end

  # -------------------------
  # Sortowanie
  # -------------------------
  @allowed_sort ~w(first_name last_name gender birthdate inserted_at)a

  defp sort(query, %{"sort_by" => field, "sort_dir" => dir})
       when dir in ["asc", "desc"] do
    field_atom = safe_atom(field)

    if field_atom in @allowed_sort do
      direction = if dir == "asc", do: :asc, else: :desc
      order_by(query, [u], [{^direction, field(u, ^field_atom)}])
    else
      query
    end
  end

  defp sort(query, _), do: query

  defp safe_atom(value) do
    try do
      String.to_existing_atom(value)
    rescue
      ArgumentError -> nil
    end
  end

  # -------------------------
  # GET /users/:id
  # -------------------------
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  # -------------------------
  # POST /users
  # -------------------------
  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  # -------------------------
  # PUT /users/:id
  # -------------------------
  def update_user(id, params) do
    id
    |> get_user!()
    |> User.changeset(params)
    |> Repo.update()
  end

  # -------------------------
  # DELETE /users/:id
  # -------------------------
  def delete_user(id) do
    id
    |> get_user!()
    |> Repo.delete()
  end
end
