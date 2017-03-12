defmodule Profilex.User.Session do
  use Ecto.Schema

  embedded_schema do
    field :email, :string
    field :password, :string
  end
end
