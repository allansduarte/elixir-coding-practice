defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, 1) when is_binary(str), do: str

  def encode(str, rails) when is_binary(str) and is_integer(rails) do
    str
    |> String.graphemes()
    |> fenciefy(rails)
    |> Enum.join()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, 1) when is_binary(str), do: str

  def decode(str, rails) when is_binary(str) do
    graphemes = String.graphemes(str)

    0..(length(graphemes) - 1)
    |> Enum.to_list()
    |> fenciefy(rails)
    |> extract(graphemes)
    |> Enum.join()
  end

  defp fenciefy(graphemes, rails) when is_list(graphemes) do
    rails
    |> empty_fence(length(graphemes))
    |> fill_fence(graphemes, rails_indexes(rails))
  end

  defp empty_fence(rows, columns) when is_integer(rows) and is_integer(columns) do
    0..(rows - 1)
    |> Enum.map(fn _ ->
      List.duplicate(nil, columns)
    end)
  end

  defp fill_fence(fence, graphemes, indexes)
       when is_list(fence) and is_list(graphemes) and is_list(indexes) do
    graphemes
    |> Stream.with_index()
    |> Enum.reduce(fence, fn {grapheme, idx}, acc ->
      rid = Enum.at(indexes, rem(idx, length(indexes)))

      List.update_at(acc, rid, fn col ->
        List.update_at(col, idx, fn _ -> grapheme end)
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(&1 !== nil))
  end

  defp rails_indexes(rails) when is_integer(rails) do
    Enum.concat(Enum.to_list(0..(rails - 1)), Enum.to_list((rails - 2)..1))
  end

  defp extract(fence, graphemes) do
    0..(length(graphemes) - 1)
    |> Enum.map(fn idx ->
      Enum.at(graphemes, Enum.find_index(fence, &(&1 == idx)))
    end)
  end
end
