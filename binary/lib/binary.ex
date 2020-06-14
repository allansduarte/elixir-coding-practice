defmodule Binary do
  @binary_string ~r/\A[01]+\z/
  @binary_base 2
  @invalid_binary 0

  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    do_decimal(@invalid_binary, string)
  end

  defp do_decimal(accumulator, binary_number) when binary_number == "", do: accumulator

  defp do_decimal(accumulator, <<first::binary-1, rest::binary>>) do
    case binary?(first) do
      true ->
        accumulator
        |> convert(first, rest)
        |> do_decimal(rest)

      false ->
        @invalid_binary
    end
  end

  defp convert(accumulator, binary_number, rest_string) do
    position = byte_size(rest_string)

    (String.to_integer(binary_number) * :math.pow(@binary_base, position) + accumulator)
    |> round()
  end

  defp binary?(string) do
    if string =~ @binary_string do
      true
    else
      false
    end
  end
end
