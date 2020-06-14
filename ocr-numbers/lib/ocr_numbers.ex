defmodule OcrNumbers do
  @number %{
    [
      " _ ",
      "| |",
      "|_|",
      "   "
    ] => "0",
    [
      "   ",
      "  |",
      "  |",
      "   "
    ] => "1",
    [
      " _ ",
      " _|",
      "|_ ",
      "   "
    ] => "2",
    [
      " _ ",
      " _|",
      " _|",
      "   "
    ] => "3",
    [
      "   ",
      "|_|",
      "  |",
      "   "
    ] => "4",
    [
      " _ ",
      "|_ ",
      " _|",
      "   "
    ] => "5",
    [
      " _ ",
      "|_ ",
      "|_|",
      "   "
    ] => "6",
    [
      " _ ",
      "  |",
      "  |",
      "   "
    ] => "7",
    [
      " _ ",
      "|_|",
      "|_|",
      "   "
    ] => "8",
    [
      " _ ",
      "|_|",
      " _|",
      "   "
    ] => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, charlist()}
  def convert(input) do
    with {:ok, _} <- valid_line_count?(input),
         {:ok, _} <- valid_column_count?(input) do
      {:ok, do_convert(input)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp do_convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&extract_numbers(&1))
    |> Enum.map(&ocr(&1))
    |> Enum.map(&Enum.join/1)
    |> Enum.join(",")
  end

  def extract_numbers(input) do
    times = div(String.length(List.first(input)), 3)
    chunk_by_3(input, 0, times, [])
  end

  def chunk_by_3(_, _, 0, acc), do: acc

  def chunk_by_3(input, start, times, acc) do
    acc = acc ++ [Enum.map(input, fn line -> binary_part(line, start, 3) end)]
    chunk_by_3(input, start + 3, times - 1, acc)
  end

  def ocr(input), do: Enum.map(input, &ocr_number(&1))

  def ocr_number(input) do
    case @number[input] do
      nil -> "?"
      number -> number
    end
  end

  defp valid_line_count?(input) do
    case multiple_of_four?(input) do
      false -> {:error, 'invalid line count'}
      _ -> {:ok, input}
    end
  end

  defp valid_column_count?(input) do
    case Enum.all?(input, &multiple_of_three?(&1)) do
      false -> {:error, 'invalid column count'}
      _ -> {:ok, input}
    end
  end

  defp multiple_of_four?(lines) do
    rem(length(lines), 4) == 0
  end

  defp multiple_of_three?(column) when is_binary(column) do
    rem(String.length(column), 3) == 0
  end
end
