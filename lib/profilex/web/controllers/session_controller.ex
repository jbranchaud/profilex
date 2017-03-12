defmodule Profilex.Web.SessionController do
  use Profilex.Web, :controller

  alias Profilex.User

  def new(conn, _params) do
    changeset = User.change_session(%User.Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case User.signin_account(session_params) do
      {:ok, account} ->
        conn
        |> put_session(:current_user, account)
        |> put_flash(:info, "Signed in successfully")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
