defmodule Pangram do
  @alphabet ?a..?z

  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    sentence
    |> String.downcase()
    |> String.to_charlist()
    |> do_pangram()
  end

  defp do_pangram(chars) do
    Enum.all?(@alphabet, &(&1 in chars))
  end
end
