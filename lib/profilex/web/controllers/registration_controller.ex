defmodule Profilex.Web.RegistrationController do
  use Profilex.Web, :controller

  alias Profilex.User

  def new(conn, _params) do
    changeset = User.change_account(%Profilex.User.Account{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"account" => account_params}) do
    case User.register_account(account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  def create(conn, %{"registration" => account_params} = params) do
    create(conn, Map.put(params, "account", account_params))
  end
end
