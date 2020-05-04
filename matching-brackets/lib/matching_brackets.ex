defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.graphemes()
    |> check_brackets([])
  end

  defp check_brackets([], stack), do: Enum.empty?(stack)

  defp check_brackets([bracket | tail], stack) when bracket in ["(", "{", "["] do
    check_brackets(tail, [bracket | stack])
  end

  defp check_brackets([bracket | tail], stack) when bracket in [")", "}", "]"] do
    Enum.at(stack, 0) === pair(bracket) and check_brackets(tail, tl(stack))
  end

  defp check_brackets([_grapheme | tail], stack), do: check_brackets(tail, stack)

  defp pair(")"), do: "("
  defp pair("}"), do: "{"
  defp pair("]"), do: "["
end
