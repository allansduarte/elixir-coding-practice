defmodule Bob do
  def hey(input) do
    input
    |> String.trim()
    |> do_hey()
  end

  defp do_hey(input) do
    cond do
      loud_question?(input) -> "Calm down, I know what I'm doing!"
      question?(input) -> "Sure."
      shouting?(input) -> "Whoa, chill out!"
      silence?(input) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp shouting?(input),
    do: input == String.upcase(input) and input != String.downcase(input)

  defp loud_question?(input), do: shouting?(input) and question?(input)

  defp question?(input), do: String.ends_with?(input, "?")
  defp silence?(input), do: input == ""
end
