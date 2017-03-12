defmodule Profilex.User do
  @moduledoc """
  The boundary for the User system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Profilex.Repo

  alias Profilex.User.{Account,Registration,Session}

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(account, %{field: value})
      {:ok, %Account{}}

      iex> create_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{})
  def create_account(%Ecto.Changeset{valid?: false} = registration) do
    {:error, %{registration | action: "insert"}}
  end
  def create_account(%Ecto.Changeset{valid?: true} = registration) do
    create_account(registration.changes)
  end
  def create_account(attrs) do
    %Account{}
    |> new_account_changeset(attrs)
    |> Repo.insert()
  end

  def register_account(attrs) do
    %Registration{}
    |> password_changeset(attrs)
    |> registration_changeset(attrs)
    |> create_account()
  end

  def signin_account(attrs) do
    %Session{}
    |> session_changeset(attrs)
    |> check_password(attrs)
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> account_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    account_changeset(account, %{})
  end

  def account_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
  end

  def change_session(%Session{} = session) do
    session_changeset(%Session{} = session, %{})
  end

  def session_changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  def new_account_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> put_change(:password_digest,
                  hashed_password(Map.get(attrs, :password)))
  end

  def registration_changeset(registration, attrs) do
    registration
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:email])
  end

  def password_changeset(%Registration{} = registration, attrs) do
    registration
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp hashed_password(nil), do: nil
  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  defp check_password(%Ecto.Changeset{valid?: false} = session, _attrs) do
    {:error, %{session | action: "insert"}}
  end
  defp check_password(session, %{"password" => password, "email" => email}) do
    account = Repo.get_by(Account, email: email)

    case authenticate(account, password) do
      true ->
        {:ok, account}
      false ->
        invalid_session =
          session
          |> add_error(:password, "password and email do not match")
        {
          :error,
          %{invalid_session | action: "insert"}
        }
    end
  end

  defp authenticate(account, password) do
    case account do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, account.password_digest)
    end
  end
end
