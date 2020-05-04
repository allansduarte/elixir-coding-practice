defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    normalized_string = String.replace(sentence, ~r([[:blank:]-]), "")

    String.length(normalized_string) == count_uniq_chars(normalized_string)
  end

  defp count_uniq_chars(sentence) do
    sentence
    |> String.codepoints()
    |> Enum.uniq()
    |> Enum.count()
  end
end
