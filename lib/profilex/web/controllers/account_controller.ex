defmodule Profilex.Web.AccountController do
  use Profilex.Web, :controller

  alias Profilex.User

  def index(conn, _params) do
    accounts = User.list_accounts()
    render(conn, "index.html", accounts: accounts)
  end

  def show(conn, %{"id" => id}) do
    account = User.get_account!(id)
    render(conn, "show.html", account: account)
  end

  def edit(conn, %{"id" => id}) do
    account = User.get_account!(id)
    changeset = User.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = User.get_account!(id)

    case User.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = User.get_account!(id)
    {:ok, _account} = User.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: account_path(conn, :index))
  end
end
