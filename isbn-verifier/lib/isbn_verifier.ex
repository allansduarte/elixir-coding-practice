defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> ISBNVerifier.isbn?("3-598-21507-X")
      true

      iex> ISBNVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) when byte_size(isbn) == 10 or byte_size(isbn) == 13 do
    Regex.scan(~r/[[:alnum:]]/, isbn)
    |> List.flatten()
    |> Enum.map(&check_verifying_digit/1)
    |> Enum.filter(&to_integer/1)
    |> Enum.map(&String.to_integer/1)
    |> calculate_isbn_validity()
  end

  def isbn?(_), do: false

  defp to_integer(digit) do
    case Integer.parse(digit) do
      {_number, _rest} ->
        true

      :error ->
        false
    end
  end

  defp calculate_isbn_validity(isbn) when length(isbn) == 10 do
    {result, _index} =
      isbn
      |> Enum.with_index()
      |> Enum.reduce({0, 0}, fn {digit, index}, {acc, _} ->
        {digit * (-1 * (index - 10)) + acc, 0}
      end)

    rem(result, 11) == 0
  end

  defp calculate_isbn_validity(_isbn), do: false

  defp check_verifying_digit(digit) do
    case String.downcase(digit) == "x" do
      true ->
        "10"

      false ->
        digit
    end
  end
end
