defmodule Profilex.User.Auth do
  alias Profilex.User.Account

  def can(:edit_account, current_user, account) do
    own_info = owns_account?(current_user, account)
  end

  def can(:update_account, current_user, account) do
    owns_account?(current_user, account)
  end

  def can(:delete_account, current_user, account) do
    owns_account?(current_user, account)
  end

  defp owns_account?(current_user, account) do
    case {current_user, account} do
      {%Account{id: id}, %Account{id: id}}   -> :ok
      {%Account{}, nil}           -> {:error, :not_found}
      _                           -> {:error, :unauthorized}
    end
  end
end
