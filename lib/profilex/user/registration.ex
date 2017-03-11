defmodule Profilex.User.Registration do
  use Ecto.Schema

  embedded_schema do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :password_confirmation, :string
  end
end
