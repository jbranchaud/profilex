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

    case edit_account(conn, account) do
      {:ok, account, changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
      {:error, error} ->
        redirect(conn, to: "/")
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = User.get_account!(id)

    case update_account(conn, account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
      {:error, error_type} ->
        redirect(conn, to: "/")
    end
  end

  def delete(conn, %{"id" => id}) do
    account = User.get_account!(id)
    {:ok, _account} = User.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: account_path(conn, :index))
  end

  defp edit_account(conn, account) do
    current_user = get_session(conn, :current_user)

    case Profilex.User.Auth.can(:edit_account, current_user, account) do
      :ok ->
        account_changeset = User.change_account(account)
        {:ok, current_user, account_changeset}
      {:error, error_type} ->
        {:error, error_type}
    end
  end

  defp update_account(conn, account, account_params) do
    current_user = get_session(conn, :current_user)

    case Profilex.User.Auth.can(:update_account, current_user, account) do
      :ok ->
        case User.update_account(account, account_params) do
          {:ok, account} -> {:ok, account}
          {:error, changeset} -> {:error, changeset}
        end
      {:error, error_type} ->
        {:error, error_type}
    end
  end
end
