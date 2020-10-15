defmodule BankAccount do
  use Agent, restart: :transient

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start_link(fn -> 0 end)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: atom()
  def close_bank(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    execute_on_account(account, fn account -> Agent.get(account, & &1) end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: atom()
  def update(account, amount) do
    execute_on_account(account, fn account -> Agent.update(account, &(&1 + amount)) end)
  end

  defp execute_on_account(account, fun) do
    if Process.alive?(account) do
      fun.(account)
    else
      {:error, :account_closed}
    end
  end
end
