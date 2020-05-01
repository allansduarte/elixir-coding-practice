defmodule Scrabble do
  @point_lookup %{
    1 => ~c(aeioulnrst),
    2 => ~c(dg),
    3 => ~c(bcmp),
    4 => ~c(fhvwy),
    5 => ~c(k),
    8 => ~c(jx),
    10 => ~c(qz)
  }

  @scores for {points, chars} <- @point_lookup,
              c <- chars,
              into: %{},
              do: {c, points}

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    ~r/[[:word:]]+/
    |> Regex.scan(String.downcase(word))
    |> List.flatten()
    |> to_string()
    |> to_charlist()
    |> Enum.map(&@scores[&1])
    |> Enum.sum()
  end
end
