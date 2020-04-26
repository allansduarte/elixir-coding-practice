defmodule PigLatin do
  @vowels "aoeui"
  @vowels_at_start ~r/^([#{@vowels}]|[xy][^#{@vowels}])/
  @consonants ~r/^([^#{@vowels}]*qu|[^#{@vowels}]+)/

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end

  defp translate_word(word) do
    if starts_with_vowel?(word) do
      word <> "ay"
    else
      with {consonants, rest} <- partition_consonants(word),
           do: rest <> consonants <> "ay"
    end
  end

  defp starts_with_vowel?(word), do: String.match?(word, @vowels_at_start)

  defp partition_consonants(word) do
    word
    |> String.split(@consonants, include_captures: true, trim: true)
    |> List.to_tuple()
  end
end
