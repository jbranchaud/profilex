defmodule Profilex.Repo.Migrations.CreateProfilex.User.Account do
  use Ecto.Migration

  def change do
    create table(:user_accounts) do
      add :first_name, :varchar, null: false
      add :last_name, :varchar, null: false
      add :email, :varchar, null: false
      add :password_digest, :varchar, null: false

      timestamps()
    end
  end
end
