defmodule Bob do
  def hey(input) do
    input
    |> String.trim()
    |> do_hey()
  end

  defp do_hey(input) do
    cond do
      is_shouting?(input) and is_question?(input) -> "Calm down, I know what I'm doing!"
      is_question?(input) -> "Sure."
      is_shouting?(input) -> "Whoa, chill out!"
      is_empty?(input) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp is_shouting?(input) do
    input
    |> do_only_words()
    |> is_yelling?()
  end

  defp is_yelling?(input),
    do: (!is_empty?(input) and input == String.upcase(input)) or String.ends_with?(input, "!")

  defp do_only_words(input), do: String.replace(input, ~r/[[:digit:][:punct:][:blank:]]/, "")

  defp is_question?(input), do: String.ends_with?(input, "?")
  defp is_empty?(input), do: input == ""
end
