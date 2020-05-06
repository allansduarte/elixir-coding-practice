defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, fn candidate -> anagram?(base, candidate) end)
  end

  defp anagram?(base, candidate) do
    cond do
      String.length(base) != String.length(candidate) or
          String.downcase(base) == String.downcase(candidate) ->
        false

      true ->
        alphabetize(base) == alphabetize(candidate)
    end
  end

  defp alphabetize(word) do
    word
    |> String.downcase()
    |> String.codepoints()
    |> Enum.sort()
  end
end
