defmodule TodoWeb.CommissionControllerTest do
  use TodoWeb.ConnCase, async: true
  use Mimic

  test "POST /api/todo creates a commission and sends email", %{conn: conn} do
    Mimic.expect(Todo.Emails, :send_email, fn _customer, _message -> :ok end)

    request_body = %{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    }

    %{"customer" => "test_user"} =
      conn
      |> post("/api/todo", request_body)
      |> json_response(201)
  end


  test "GET /api/todo returns list of commissions", %{conn: conn} do
    {:ok, _} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user1",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    {:ok, _} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user2",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })

    response =
      conn
      |> get("/api/todo")
      |> json_response(200)

    customers = Enum.map(response, & &1["customer"])
    assert "test_user1" in customers
    assert "test_user2" in customers
  end


  test "GET /api/todo/:id returns a commission", %{conn: conn} do
    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })

    %{"customer" => "test_user"} =
      conn
      |> get("/api/todo/#{commission.id}")
      |> json_response(200)
  end

  test "GET /api/todo/:id with invalid id returns not found", %{conn: conn} do
    %{"error" => "not found"} =
      conn
      |> get("/api/todo/#{Ecto.UUID.generate()}")
      |> json_response(404)
  end

  test "POST /api/todo with invalid data returns errors", %{conn: conn} do
    request_body = %{
      customer: "test_user",
      type: "full_body",
      status: "invalid_status",
      deadline: ~U[2026-12-31 00:00:00Z]
    }

    %{"errors" => %{"status" => ["is invalid"]}} =
      conn
      |> post("/api/todo", request_body)
      |> json_response(422)
  end

  test "PUT /api/todo/:id updates a commission", %{conn: conn} do
    Mimic.expect(Todo.Emails, :send_email, fn _customer, _message -> :ok end)

    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })
    request_body = %{status: "lining"}

    %{"status" => "lining"} =
      conn
      |> put("/api/todo/#{commission.id}", request_body)
      |> json_response(200)

  end

  test "DELETE /api/todo/:id deletes a commission", %{conn: conn} do
    Mimic.expect(Todo.Emails, :send_email, fn _customer, _message -> :ok end)

    {:ok, commission} = Todo.Repo.insert(%Todo.Commission{
      customer: "test_user",
      type: "full_body",
      status: "sketching",
      deadline: ~U[2026-12-31 00:00:00Z]
    })

    conn
    |> delete("/api/todo/#{commission.id}")
    |> response(204)

    assert Todo.Commissions.fetch_commission(commission.id) == {:error, :not_found}
  end

end
