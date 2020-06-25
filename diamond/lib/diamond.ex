defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    row = build_letter(letter, letter)
    before = build_before(letter, letter - 1)

    before
    |> Enum.reverse()
    |> Enum.concat([row | before])
    |> Enum.join()
  end

  defp build_letter(ref, letter) do
    diff_after = ref - letter

    cond do
      letter == ?A ->
        String.duplicate(" ", diff_after) <>
          <<letter>> <> String.duplicate(" ", diff_after) <> "\n"

      true ->
        diff_before = (letter - ?A) * 2 - 1

        String.duplicate(" ", diff_after) <>
          <<letter>> <>
          String.duplicate(" ", diff_before) <>
          <<letter>> <> String.duplicate(" ", diff_after) <> "\n"
    end
  end

  defp build_before(ref, ?A), do: [build_letter(ref, ?A)]

  defp build_before(ref, letter) do
    [build_letter(ref, letter) | build_before(ref, letter - 1)]
  end
end
