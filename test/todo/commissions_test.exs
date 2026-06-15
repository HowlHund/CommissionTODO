defmodule Todo.CommissionsTest do
  use Todo.DataCase
  alias Todo.Commissions
  alias Todo.Commission
  alias Todo.Repo

  describe "list_commissions/0" do
    test "returns all commissions" do
      {:ok, _commission} = Repo.insert(%Commission{
        customer: "test_user1",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      {:ok, _commission} = Repo.insert(%Commission{
        customer: "test_user2",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })

    result = Commissions.list_commissions()
    assert length(result) == 2
    customers = Enum.map(result, & &1.customer)
    assert "test_user1" in customers
    assert "test_user2" in customers
    end
  end

  describe "fetch_commission/1 with valid id" do
    test "returns a commission by id" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      result = Commissions.fetch_commission(commission.id)
      assert {:ok, %Commission{} = c} = result
      assert c.customer == commission.customer
      assert c.type == commission.type
      assert c.status == commission.status
      assert c.deadline == commission.deadline
    end
  end

  describe "fetch_commission/1 with invalid id" do
    test "returns not found error" do
      result = Commissions.fetch_commission(Ecto.UUID.generate())
      assert result == {:error, :not_found}
    end
  end

  describe "create_commission/1 with valid data" do
    test "creates a commission" do
      attrs = %{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      }
      assert {:ok, %Commission{} = c} = Commissions.create_commission(attrs)
      assert c.customer == attrs.customer
      assert c.type == attrs.type
      assert c.status == attrs.status
      assert c.deadline == attrs.deadline
    end
  end

  describe "create_commission/1 with invalid status" do
    test "returns error changeset with invalid status" do
      attrs = %{
        customer: "test_user",
        type: "full_body",
        status: "invalid_status",
        deadline: ~U[2026-12-31 00:00:00Z]
      }
      assert {:error, %Ecto.Changeset{}} = Commissions.create_commission(attrs)
    end
  end

  describe "create_commission/1 with invalid type" do
    test "returns error changeset with invalid type" do
      attrs = %{
        customer: "test_user",
        type: "invalid_type",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      }
      assert {:error, %Ecto.Changeset{}} = Commissions.create_commission(attrs)
    end
  end

  describe "create_commission/1 with missing required fields" do
    test "returns error changeset with missing required fields" do
      attrs = %{
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      }
      assert {:error, %Ecto.Changeset{}} = Commissions.create_commission(attrs)
    end
  end

  describe "update_commission/2 with valid data" do
    test "updates a commission" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      update_attrs = %{status: "coloring"}
      assert {:ok, %Commission{} = c} = Commissions.update_commission(commission, update_attrs)
      assert c.status == update_attrs.status
    end
  end

  describe "update_commission/2 with invalid status" do
    test "returns error changeset with invalid status" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      update_attrs = %{status: "invalid_status"}
      assert {:error, %Ecto.Changeset{}} = Commissions.update_commission(commission, update_attrs)
    end
  end

  describe "update_commission/2 with invalid type" do
    test "returns error changeset with invalid type" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      update_attrs = %{type: "invalid_type"}
      assert {:error, %Ecto.Changeset{}} = Commissions.update_commission(commission, update_attrs)
    end
  end

  describe "update_commission/2 with missing required fields" do
    test "returns error changeset with missing required fields" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      update_attrs = %{customer: nil}
      assert {:error, %Ecto.Changeset{}} = Commissions.update_commission(commission, update_attrs)
    end
  end

  describe "delete_commission/1" do
    test "deletes a commission" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      assert {:ok, %Commission{}} = Commissions.delete_commission(commission)
      assert Repo.get(Commission, commission.id) == nil
    end
  end

end
