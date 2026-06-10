defmodule Todo.Commissions do
  alias Todo.Repo
  alias Todo.Commission

  def list_commissions do # this returns all the comms in our db
    Repo.all(Commission)
  end

  def get_commission!(id) do # this gets a single comm by it's uuid. ! means it will throw an error if it can't find one
    Repo.get!(Commission, id)
  end

  def create_commission(attrs \\ %{}) do #this uses %{} to give us an empty map for a commission slot
    %Commission{}
    |> Commission.changeset(attrs) #then sends it to changeset to validate the attributes
    |> Repo.insert() #then inserts it into our db
  end

  def update_commission(%Commission{} = commission, attrs) do #takes in an existing commission and it's attributes that need to change
    commission #we give it a curl command with the id of the commission we want to change and the attributes we want to change in the body, then it pattern matches the commission structure
    |> Commission.changeset(attrs) #validates the changes
    |> Repo.update() #sends it to the repo file to be turned into a query and sent to the database
  end

  def delete_commission(%Commission{} = commission) do #pattern matches the commission structure
    Repo.delete(commission) #sends it to the repo file to be turned into a query and sent to the database. You'll see repo used a lot, and in general that's what it's doing.
  end
end
