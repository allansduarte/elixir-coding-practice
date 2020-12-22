defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    case {opts[:white], opts[:black]} do
      {x, x} ->
        raise ArgumentError, message: "Cannot occupy same space"

      {nil, nil} ->
        raise ArgumentError, message: "Cannot be no argument white or black"

      {black, white} ->
        if valid?(white, black) do
          %Queens{black: white, white: black}
        else
          raise ArgumentError, message: "Cannot be out of map"
        end
    end
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{white: {wx, wy}, black: {bx, by}}) do
    "_ _ _ _ _ _ _ _"
    |> List.duplicate(8)
    |> List.update_at(
      wx,
      &(String.slice(&1, min(2 * wy - 1, 0)..max(2 * wy - 1, 0)) <>
          "W" <> String.slice(&1, (2 * wy + 1)..14))
    )
    |> List.update_at(
      bx,
      &(String.slice(&1, min(2 * by - 1, 0)..max(2 * by - 1, 0)) <>
          "B" <> String.slice(&1, (2 * by + 1)..14))
    )
    |> Enum.join("\n")
  end

  def to_string(%Queens{black: {bx, by}}) do
    "_ _ _ _ _ _ _ _"
    |> List.duplicate(8)
    |> List.update_at(
      bx,
      &(String.slice(&1, min(2 * by - 1, 0)..max(2 * by - 1, 0)) <>
          "B" <> String.slice(&1, (2 * by + 1)..14))
    )
    |> Enum.join("\n")
  end

  def to_string(%Queens{white: {wx, wy}}) do
    "_ _ _ _ _ _ _ _"
    |> List.duplicate(8)
    |> List.update_at(
      wx,
      &(String.slice(&1, min(2 * wy - 1, 0)..max(2 * wy - 1, 0)) <>
          "W" <> String.slice(&1, (2 * wy + 1)..14))
    )
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {bx, by}, white: {wx, wy}}) do
    bx == wx or by == wy or abs(bx - wx) == abs(by - wy)
  end

  def can_attack?(%Queens{black: _pos}) do
    false
  end

  def can_attack?(%Queens{white: _pos}) do
    false
  end

  def can_attack(_queens) do
    false
  end

  defp valid?(nil) do
    true
  end

  defp valid?({x, y}) do
    x in 0..7 and y in 0..7
  end

  defp valid?(white, black) do
    valid?(white) and valid?(black)
  end
end
