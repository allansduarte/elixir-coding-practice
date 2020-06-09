defmodule LinkedList do
  @opaque t :: tuple()

  defstruct elem: nil, tail: nil

  @empty_list_error {:error, :empty_list}

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    %LinkedList{}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem) do
    %LinkedList{elem: elem, tail: list}
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(%LinkedList{elem: nil, tail: nil}), do: 0
  def length(%LinkedList{} = list), do: 1 + LinkedList.length(list.tail)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(%LinkedList{elem: nil}), do: true
  def empty?(_list), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(%LinkedList{elem: nil}), do: @empty_list_error
  def peek(list), do: {:ok, list.elem}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(%LinkedList{elem: nil}), do: @empty_list_error

  def tail(list) do
    {:ok, list.tail}
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(%LinkedList{elem: nil}), do: @empty_list_error

  def pop(list) do
    {:ok, list.elem, list.tail}
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list([]), do: %LinkedList{}

  def from_list([head | tail]) do
    %LinkedList{elem: head, tail: from_list(tail)}
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(%LinkedList{elem: nil}), do: []

  def to_list(list) do
    [list.elem | to_list(list.tail)]
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    do_reverse(list, %LinkedList{})
  end

  defp do_reverse(%LinkedList{elem: nil}, reversed), do: reversed

  defp do_reverse(list, reversed) do
    do_reverse(list.tail, reversed |> LinkedList.push(list.elem))
  end
end
