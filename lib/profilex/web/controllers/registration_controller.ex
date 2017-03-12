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
        successful_account_creation(conn, account)
      {:error, %Ecto.Changeset{} = changeset} ->
        failed_account_creation(conn, changeset)
    end
  end

  defp successful_account_creation(conn, account) do
    conn
    |> put_flash(:info, "Account created successfully.")
    |> redirect(to: account_path(conn, :show, account))
  end

  defp failed_account_creation(conn, changeset_with_errors) do
    conn
    |> render("new.html", changeset: changeset_with_errors)
  end
end
