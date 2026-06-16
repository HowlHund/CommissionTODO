defmodule Todo.Commission do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:id, :customer, :type, :status, :notes,
    :deadline, :inserted_at, :updated_at]} #specifies which fields to include in the JSON response
    @primary_key {:id, :binary_id, autogenerate: true} #this is for our uuid

    @fields [:customer, :type, :status, :notes, :deadline]
    @required_fields [:customer, :type, :status]
    @valid_types ["full_body", "half_body", "head_shot", "ref", "chibi"]
    @valid_statuses ["sketching", "lining", "coloring", "shading", "polishing", "completed", "cancelled"]

    schema "commissions" do #This is our schema for how a commission slot looks like in our "todo"
      field :customer, :string
      field :type, :string
      field :status, :string
      field :notes, :string #we cant use :text because it isnt supported by roach
      field :deadline, :utc_datetime

      timestamps()
    end

    def changeset(commission, attrs) do #this function validates a commission slot's attributes
      commission
      |> cast(attrs, @fields) #only accepts this pattern
      |> validate_required(@required_fields) #requires these fields to be present
      |> validate_inclusion(:status, @valid_statuses) #status must be one of these values
      |> validate_inclusion(:type, @valid_types) #type must be one of these values
    end
end
