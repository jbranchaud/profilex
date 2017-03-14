defmodule Profilex.Web.AccountController do
  use Profilex.Web, :controller

  alias Profilex.User

  plug :authenticate_user when action in [:edit, :update, :delete]

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

  defp authenticate_user(%{params: %{"id" => id}} = conn, _opts) do
    current_user_id = conn |> get_session(:current_user) |> Map.get(:id) |> to_string()

    case current_user_id do
      ^id -> conn
      _   -> redirect(conn, to: page_path(conn, :index)) |> halt()
    end
  end
end
