defmodule TodoWeb.FallbackController do
  use TodoWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "not found"})
  end
end
