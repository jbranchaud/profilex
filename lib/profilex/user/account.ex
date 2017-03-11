defmodule Profilex.User.Account do
  use Ecto.Schema

  schema "user_accounts" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_digest, :string

    timestamps()
  end
end
