defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    []
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(game, roll) do
    case allow_to_roll(game, roll) do
      {:error, _} = error ->
        error

      _ ->
        do_roll(game, roll)
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(game) do
    case allow_to_calc_score(game) do
      {:error, _} = error ->
        error

      _ ->
        game |> Enum.reverse() |> frame_score(0)
    end
  end

  defp allow_to_roll([{:open, _} | _] = game, _roll) when length(game) == 10 do
    {:error, "Cannot roll after game is over"}
  end

  defp allow_to_roll([{:fill, _}, {:spare, _} | _], _roll) do
    {:error, "Cannot roll after game is over"}
  end

  defp allow_to_roll([{:fill, _}, {:fill, _} | _], _roll) do
    {:error, "Cannot roll after game is over"}
  end

  defp allow_to_roll([{:fill, r} | _], roll) when r < 10 and r + roll > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  defp allow_to_roll(_, roll) when roll > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  defp allow_to_roll(_, roll) when roll < 0 do
    {:error, "Negative roll is invalid"}
  end

  defp allow_to_roll([{:ongoing, r} | _], roll) when roll + r > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  defp allow_to_roll(_, _), do: :ok

  defp do_roll([{:ongoing, r} | frames], roll) when r + roll < 10 do
    [{:open, {r, roll}} | frames]
  end

  defp do_roll([{:ongoing, r} | frames], roll) do
    [{:spare, {r, roll}} | frames]
  end

  defp do_roll(game, roll) when length(game) >= 10 do
    [{:fill, roll} | game]
  end

  defp do_roll(game, 10), do: [:strike | game]
  defp do_roll(game, roll), do: [{:ongoing, roll} | game]

  defp allow_to_calc_score([{:ongoing, _} | _]) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  defp allow_to_calc_score(game) when length(game) < 10 do
    {:error, "Score cannot be taken until the end of the game"}
  end

  defp allow_to_calc_score([{:fill, 10}, :strike | _]) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  defp allow_to_calc_score([{:spare, _} | _]) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  defp allow_to_calc_score([:strike | _]) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  defp allow_to_calc_score(_), do: :ok

  defp with_next_throws(0, _, total), do: total

  defp with_next_throws(n, [:strike | frames], total) do
    with_next_throws(n - 1, frames, total + 10)
  end

  defp with_next_throws(2, [{_, {r1, r2}} | _], total) do
    total + r1 + r2
  end

  defp with_next_throws(1, [{_, {r1, _}} | _], total) do
    total + r1
  end

  defp with_next_throws(n, [{:fill, roll} | frames], total) do
    with_next_throws(n - 1, frames, total + roll)
  end

  defp frame_score([], total), do: total

  defp frame_score([{:fill, _} | _], total) do
    total
  end

  defp frame_score([:strike | frames], total) do
    frame_score(frames, with_next_throws(2, frames, total + 10))
  end

  defp frame_score([{:spare, _} | frames], total) do
    frame_score(frames, with_next_throws(1, frames, total + 10))
  end

  defp frame_score([{:open, {r1, r2}} | frames], total) do
    frame_score(frames, total + r1 + r2)
  end
end
