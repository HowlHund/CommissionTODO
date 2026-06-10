defmodule TodoWeb.CommissionController do
  use TodoWeb, :controller
  action_fallback TodoWeb.FallbackController
  alias Todo.Commissions



  def index(conn, _params) do
    commissions = Commissions.list_commissions()
    json(conn, commissions)
  end

  def show(conn, params) do
  commission = Commissions.get_commission!(params["id"])
  json(conn, commission)
  rescue
  Ecto.NoResultsError -> {:error, :not_found}
  end


  def create(conn, params) do
    case Commissions.create_commission(params) do
      {:ok, commission} ->
        conn
        |> put_status(:created)
        |> json(commission)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
    end
  end

  def update(conn, params) do
    case Commissions.update_commission(Commissions.get_commission!(params["id"]), params) do
      {:ok, commission} ->
        conn
        |> put_status(:ok)
        |> json(commission)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
    end
  end

  def delete(conn, params) do
    case Commissions.delete_commission(Commissions.get_commission!(params["id"])) do
      {:ok, _commission} -> send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
    end
  end
end
