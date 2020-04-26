defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    # split the phrase to do recursion
    |> String.split()
    |> generate_acronym("")
  end

  defp generate_acronym([head | tail], accumulator) do
    acronym =
      head
      # get just letters
      |> String.replace(~r"[^a-zA-Z]+", "")
      # get the first letter from an acronym or capitalize a sentence
      |> normalize_acronym()
      # get just upper letters from a sentence
      |> String.replace(~r"[^A-Z]+", "")

    generate_acronym(tail, "#{accumulator}#{acronym}")
  end

  defp generate_acronym([], acronym), do: acronym

  defp normalize_acronym(str) do
    acronym = String.slice(str, 0..2)

    if acronym =~ ~r(^[^a-z]*$) do
      String.at(acronym, 0) || ""
    else
      <<first::utf8, rest::binary>> = str
      String.upcase(<<first::utf8>>) <> rest
    end
  end

  defp normalize_acronym("" = empty_string), do: empty_string
end
