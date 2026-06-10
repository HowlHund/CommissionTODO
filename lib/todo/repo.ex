defmodule Todo.Repo do
  use Ecto.Repo, #we use Ecto to convert all our elixir code into SQL queries that our database can understand
    otp_app: :todo,
    adapter: Ecto.Adapters.Postgres
end
