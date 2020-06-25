defmodule BankAccount do
  alias BankAccount.ProcessTransactions

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
    {:ok, account} = ProcessTransactions.open_account(0)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    ProcessTransactions.close_account(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    ProcessTransactions.balance(account)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    ProcessTransactions.update_account(account, amount)
  end
end

defmodule BankAccount.ProcessTransactions do
  use GenServer

  def init(state), do: {:ok, state}

  def handle_call(_, _, :closed), do: {:reply, {:error, :account_closed}, :closed}

  def handle_call(:balance, _, balance), do: {:reply, balance, balance}

  def handle_call({:update, amount}, _, balance) do
    new_balance = balance + amount
    {:reply, new_balance, new_balance}
  end

  def handle_cast(:close, _),
    do: {:noreply, :closed}

  def open_account(0), do: GenServer.start_link(__MODULE__, 0)

  def close_account(account), do: GenServer.cast(account, :close)

  def balance(account), do: GenServer.call(account, :balance)

  def update_account(account, amount), do: GenServer.call(account, {:update, amount})
end
