defmodule TodoWeb.CommissionControllerTest do
  use TodoWeb.ConnCase, async: true
  use Mimic

  test "POST /api/todo creates a commission and sends email", %{conn: conn} do
    Mimic.expect(Todo.Emails, :send_email, fn _customer, _message -> :ok end)

    conn = post(conn, "/api/todo", %{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    assert json_response(conn, 201)["customer"] == "test_user"
  end

  test "GET /api/todo returns list of commissions", %{conn: conn} do
    {:ok, _commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    assert length(json_response(get(conn, "/api/todo"), 200)) >= 1
  end

  test "GET /api/todo/:id returns a commission", %{conn: conn} do
    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    assert json_response(get(conn, "/api/todo/#{commission.id}"), 200)["customer"] == "test_user"
  end

  test "GET /api/todo/:id with invalid id returns not found", %{conn: conn} do
    assert json_response(get(conn, "/api/todo/#{Ecto.UUID.generate()}"), 404)["error"] == "not found"
  end

  test "POST /api/todo with invalid data returns errors", %{conn: conn} do
    conn = post(conn, "/api/todo", %{
      customer: "test_user",
      type: "full_body",
      status: "invalid_status",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    assert json_response(conn, 422)["errors"]["status"] == ["is invalid"]
  end

  test "PUT /api/todo/:id updates a commission", %{conn: conn} do
    Mimic.expect(Todo.Emails, :send_email, fn _customer, _message -> :ok end)

    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    conn = put(conn, "/api/todo/#{commission.id}", %{
      status: "lining"
    })
    assert json_response(conn, 200)["status"] == "lining"
  end

  test "DELETE /api/todo/:id deletes a commission", %{conn: conn} do
    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    conn = delete(conn, "/api/todo/#{commission.id}")
    assert response(conn, 204)
    assert Todo.Commissions.fetch_commission(commission.id) == {:error, :not_found}
  end
end
