defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> do_count_elixir_1_10_x()
    # |> do_count_elixir()
  end

  defp do_count_elixir(sentence) do
    Regex.scan(~r/[[:alpha:][:digit:]-]+/u, sentence)
    |> List.flatten()
    |> Enum.reduce(Map.new(), &do_count/2)
  end

  defp do_count(word, map) do
    Map.update(map, word, 1, &(&1 + 1))
  end

  defp do_count_elixir_1_10_x(sentence) do
    Regex.scan(~r/[[:alpha:][:digit:]-]+/u, sentence)
    |> List.flatten()
    |> Enum.frequencies()
  end
end
