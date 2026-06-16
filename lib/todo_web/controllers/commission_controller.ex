defmodule TodoWeb.CommissionController do
  use TodoWeb, :controller
  action_fallback TodoWeb.FallbackController
  alias Todo.Commissions
  alias Todo.Emails


  def index(conn, _params) do
    commissions = Commissions.list_commissions()
    json(conn, commissions)
  end

  def show(conn, params) do
    case Commissions.fetch_commission(params["id"]) do
    {:ok, commission} ->
      json(conn, commission)
    {:error, :not_found} ->
      conn
      |> put_status(:not_found)
      |> json(%{error: "not found"})
    end
  end


  def create(conn, params) do
    case Commissions.create_commission(params) do
      {:ok, commission} ->
        Emails.send_email(commission.customer, "Your commission has been created.")
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
    with {:ok, commission} <- Commissions.fetch_commission(params["id"]),
         {:ok, updated} <- Commissions.update_commission(commission, params) do
          Emails.send_email(commission.customer, "Your commission has been updated.")
      json(conn, updated)
    else
      {:error, :not_found} ->
        conn |> put_status(:not_found) |> json(%{error: "not found"})
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
    end
  end

  def delete(conn, params) do
    with {:ok, commission} <- Commissions.fetch_commission(params["id"]),
        {:ok, _deleted} <- Commissions.delete_commission(commission) do
          Emails.send_email(commission.customer, "Your commission has been deleted.")
      send_resp(conn, :no_content, "")
    else
      {:error, :not_found} ->
        conn |> put_status(:not_found) |> json(%{error: "not found"})
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)})
    end
  end
end
