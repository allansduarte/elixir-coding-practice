defmodule Zipper do
  @type direction :: :left | :right | :value
  @type parent :: nil | {direction(), BinTree.t()}
  @type t :: %Zipper{parent: parent(), tree: BinTree.t()}

  defstruct [:parent, :tree]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{tree: bin_tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{parent: nil, tree: bin_tree}), do: bin_tree

  def to_tree(zipper) do
    zipper
    |> up()
    |> to_tree()
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{tree: tree}), do: tree.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper), do: move(zipper, :left)

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper), do: move(zipper, :right)

  @spec move(Zipper.t(), direction()) :: Zipper.t() | nil
  defp move(zipper, dir) do
    case Map.get(zipper.tree, dir) do
      nil ->
        nil

      tree ->
        %Zipper{
          parent: {dir, zipper},
          tree: tree
        }
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{parent: nil}), do: nil

  def up(%Zipper{parent: {:left, parent}, tree: tree}) do
    parent_tree = %BinTree{parent.tree | left: tree}
    %Zipper{parent | tree: parent_tree}
  end

  def up(%Zipper{parent: {:right, parent}, tree: tree}) do
    parent_tree = %BinTree{parent.tree | right: tree}
    %Zipper{parent | tree: parent_tree}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    updated_tree = %BinTree{zipper.tree | value: value}
    %Zipper{zipper | tree: updated_tree}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left), do: update_tree(zipper, :left, left)

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right), do: update_tree(zipper, :right, right)

  @spec update_tree(Zipper.t(), direction(), BinTree.t() | nil) :: Zipper.t()
  defp update_tree(zipper, dir, branch) do
    %Zipper{zipper | tree: Map.put(zipper.tree, dir, branch)}
  end
end
