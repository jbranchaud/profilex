defmodule Profilex.User.Auth do
  alias Profilex.User.Account

  def can(:edit_account, current_user, account) do
    case {current_user, account} do
      {user = %Account{}, user}   -> :ok
      {%Account{}, nil}           -> {:error, :not_found}
      _                           -> {:error, :unauthorized}
    end
  end
end
