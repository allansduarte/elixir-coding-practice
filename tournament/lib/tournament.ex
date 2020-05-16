defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> aggregate_scores
    |> sort_scores
    |> Enum.map(&stringify_score/1)
    |> scoreboard
  end

  defp scoreboard(score_strings) do
    legend = ~s[#{String.pad_trailing("Team", 31, " ")}| MP |  W |  D |  L |  P]

    score_strings
    |> Enum.reduce(legend, &(&2 <> "\n" <> &1))
  end

  defp stringify_score({team, {m, w, d, l, p}}) do
    team
    |> String.pad_trailing(31, " ")
    |> Kernel.<>("|  #{m} |  #{w} |  #{d} |  #{l} |  #{p}")
  end

  defp sort_scores(score_map) do
    score_map
    |> Enum.sort(fn {k1, {_, _, _, _, p1}}, {k2, {_, _, _, _, p2}} ->
      p1 > p2 || (p1 == p2 && k1 < k2)
    end)
  end

  defp aggregate_scores(input) do
    input
    |> Enum.reduce(%{}, fn score_string, acc ->
      with [team1, team2, outcome] <- String.split(score_string, ";") do
        acc |> add_scores(team1, team2, outcome)
      else
        _ -> acc
      end
    end)
  end

  defp add_scores(acc, team1, team2, outcome) do
    case outcome do
      "win" ->
        acc
        |> Map.put(team1, update_score(acc[team1], :win))
        |> Map.put(team2, update_score(acc[team2], :loss))

      "loss" ->
        add_scores(acc, team2, team1, "win")

      "draw" ->
        acc
        |> Map.put(team1, update_score(acc[team1], :draw))
        |> Map.put(team2, update_score(acc[team2], :draw))

      _ ->
        acc
    end
  end

  defp update_score(nil, outcome), do: update_score({0, 0, 0, 0, 0}, outcome)
  defp update_score({m, w, d, l, p}, :win), do: {m + 1, w + 1, d, l, p + 3}
  defp update_score({m, w, d, l, p}, :draw), do: {m + 1, w, d + 1, l, p + 1}
  defp update_score({m, w, d, l, p}, :loss), do: {m + 1, w, d, l + 1, p + 0}
end
