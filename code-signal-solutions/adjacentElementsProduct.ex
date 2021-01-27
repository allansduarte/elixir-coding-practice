@min_value -1000

def adjacentElementsProduct(input_array) do
 find_largest_adjacent_elements(input_array, @min_value)
end

defp find_largest_adjacent_elements(input_array, acc) when length(input_array) == 1, do: acc
defp find_largest_adjacent_elements([first | tail], acc) do
    [second | _rest] = tail

    acc
    |> get_largest_adjacent_value(first * second)
    |> (&find_largest_adjacent_elements(tail, &1)).()
end

defp get_largest_adjacent_value(acc, value) when acc > value, do: acc
defp get_largest_adjacent_value(_acc, value), do: value
