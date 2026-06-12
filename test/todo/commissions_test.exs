defmodule Todo.CommissionsTest do
  use Todo.DataCase
  alias Todo.Commissions
  alias Todo.Commission
  alias Todo.Repo

  describe "list_commissions/0" do
    test "returns all commissions" do
      {:ok, _commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })

    result = Commissions.list_commissions()
    assert length(result) == 1
    assert hd(result).customer == "test_user"
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
      assert {:ok, %Commission{customer: "test_user"}} = result
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
      assert {:ok, %Commission{customer: "test_user"}} = Commissions.create_commission(attrs)
    end
  end

  describe "create_commission/1 with invalid data" do
    test "returns error changeset" do
      attrs = %{
        customer: "test_user",
        type: "full_body",
        status: "testing",
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
      assert {:ok, %Commission{status: "coloring"}} = Commissions.update_commission(commission, update_attrs)
    end
  end

  describe "update_commission/2 with invalid data" do
    test "returns error changeset" do
      {:ok, commission} = Repo.insert(%Commission{
        customer: "test_user",
        type: "full_body",
        status: "sketching",
        deadline: ~U[2026-12-31 00:00:00Z]
      })
      update_attrs = %{status: "testing"}
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
