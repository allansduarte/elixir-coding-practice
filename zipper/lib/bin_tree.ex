defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}

  defstruct [:value, :left, :right]

  @spec update_at(BinTree.t(), list(:left | :right), :left | :right | :value, any) :: BinTree.t()
  def update_at(bin_tree, directions, elem_to_update, value) do
    case directions do
      [h | t] ->
        bin_tree |> Map.put(h, bin_tree |> Map.get(h) |> update_at(t, elem_to_update, value))

      [] ->
        bin_tree |> Map.put(elem_to_update, value)
    end
  end

  def get_at(nil, _), do: nil

  @spec get_at(BinTree.t(), list(:left | :right)) :: any
  def get_at(bin_tree, directions) do
    case directions do
      [h | t] -> bin_tree |> Map.get(h) |> get_at(t)
      [] -> bin_tree.value
    end
  end
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end
