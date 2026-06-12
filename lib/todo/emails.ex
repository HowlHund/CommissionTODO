defmodule Todo.Emails do

  def send_email(username, message) do
    IO.puts("Sending email to #{username}: #{message}")
    {:ok, :email_sent}
  end
end
