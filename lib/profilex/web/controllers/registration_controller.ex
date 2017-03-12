defmodule Profilex.Web.RegistrationController do
  use Profilex.Web, :controller

  alias Profilex.User

  def new(conn, _params) do
    changeset = User.prepare_registration(%Profilex.User.Registration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => account_params}) do
    case User.register_account(account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
