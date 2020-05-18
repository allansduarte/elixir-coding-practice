defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _), do: :not_found

  def search(numbers, key) do
    do_search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(_numbers, _key, l, h) when l > h, do: :not_found

  defp do_search(numbers, key, l, h) do
    m = div(l + h, 2)

    case elem(numbers, m) do
      ^key -> {:ok, m}
      num when key > num -> do_search(numbers, key, m + 1, h)
      num when key < num -> do_search(numbers, key, l, m - 1)
    end
  end
end
