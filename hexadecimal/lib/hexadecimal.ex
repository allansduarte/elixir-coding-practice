defmodule Hexadecimal do
  @invalid_hex 0
  @hex_table %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "A" => 10,
    "B" => 11,
    "C" => 12,
    "D" => 13,
    "E" => 14,
    "F" => 15
  }

  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    hex
    |> String.trim()
    |> String.upcase()
    |> String.codepoints()
    |> parse()
    |> do_to_decimal(@invalid_hex)
  end

  defp parse(hex_list) when is_list(hex_list) do
    case Enum.all?(hex_list, &parse/1) do
      false ->
        :invalid

      true ->
        Enum.map(hex_list, &hexadecimal?/1)
    end
  end
  defp parse(hex) do
    case Map.fetch(@hex_table, hex) do
      {:ok, _} ->
        true

      :error ->
        false
    end
  end

  defp hexadecimal?(hex),
    do: Enum.find(@hex_table, &hexadecimal?(&1, hex))
  defp hexadecimal?({hex_table_value, _decimal}, hex), do: hex === hex_table_value

  defp do_to_decimal(:invalid, @invalid_hex), do: @invalid_hex
  defp do_to_decimal([], decimal_result), do: decimal_result
  defp do_to_decimal([{_hex, decimal} | tail] = hex_parsed, decimal_result_prev) do
    decimal_result = round(decimal * :math.pow(16, length(hex_parsed) - 1) + decimal_result_prev)
    do_to_decimal(tail, decimal_result)
  end
end
