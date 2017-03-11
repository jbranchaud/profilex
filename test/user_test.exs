defmodule Profilex.UserTest do
  use Profilex.DataCase

  alias Profilex.User
  alias Profilex.User.Account

  @create_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

  def fixture(:account, attrs \\ @create_attrs) do
    {:ok, account} = User.create_account(attrs)
    account
  end

  test "list_accounts/1 returns all accounts" do
    account = fixture(:account)
    assert User.list_accounts() == [account]
  end

  test "get_account! returns the account with given id" do
    account = fixture(:account)
    assert User.get_account!(account.id) == account
  end

  test "create_account/1 with valid data creates a account" do
    assert {:ok, %Account{} = account} = User.create_account(@create_attrs)
    
    assert account.email == "some email"
    assert account.first_name == "some first_name"
    assert account.last_name == "some last_name"
  end

  test "create_account/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = User.create_account(@invalid_attrs)
  end

  test "update_account/2 with valid data updates the account" do
    account = fixture(:account)
    assert {:ok, account} = User.update_account(account, @update_attrs)
    assert %Account{} = account
    
    assert account.email == "some updated email"
    assert account.first_name == "some updated first_name"
    assert account.last_name == "some updated last_name"
  end

  test "update_account/2 with invalid data returns error changeset" do
    account = fixture(:account)
    assert {:error, %Ecto.Changeset{}} = User.update_account(account, @invalid_attrs)
    assert account == User.get_account!(account.id)
  end

  test "delete_account/1 deletes the account" do
    account = fixture(:account)
    assert {:ok, %Account{}} = User.delete_account(account)
    assert_raise Ecto.NoResultsError, fn -> User.get_account!(account.id) end
  end

  test "change_account/1 returns a account changeset" do
    account = fixture(:account)
    assert %Ecto.Changeset{} = User.change_account(account)
  end
end
