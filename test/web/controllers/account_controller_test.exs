defmodule Profilex.Web.AccountControllerTest do
  use Profilex.Web.ConnCase

  alias Profilex.User

  @create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

  def fixture(:account) do
    {:ok, account} = User.create_account(@create_attrs)
    account
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, account_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Accounts"
  end

  test "renders form for new accounts", %{conn: conn} do
    conn = get conn, account_path(conn, :new)
    assert html_response(conn, 200) =~ "New Account"
  end

  test "creates account and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == account_path(conn, :show, id)

    conn = get conn, account_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Account"
  end

  test "does not create account and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: @invalid_attrs
    assert html_response(conn, 200) =~ "New Account"
  end

  test "renders form for editing chosen account", %{conn: conn} do
    account = fixture(:account)
    conn = get conn, account_path(conn, :edit, account)
    assert html_response(conn, 200) =~ "Edit Account"
  end

  test "updates chosen account and redirects when data is valid", %{conn: conn} do
    account = fixture(:account)
    conn = put conn, account_path(conn, :update, account), account: @update_attrs
    assert redirected_to(conn) == account_path(conn, :show, account)

    conn = get conn, account_path(conn, :show, account)
    assert html_response(conn, 200) =~ "some updated email"
  end

  test "does not update chosen account and renders errors when data is invalid", %{conn: conn} do
    account = fixture(:account)
    conn = put conn, account_path(conn, :update, account), account: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Account"
  end

  test "deletes chosen account", %{conn: conn} do
    account = fixture(:account)
    conn = delete conn, account_path(conn, :delete, account)
    assert redirected_to(conn) == account_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, account_path(conn, :show, account)
    end
  end
end
