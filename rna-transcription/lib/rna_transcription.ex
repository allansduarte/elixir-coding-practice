defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """

  @rna_map %{
    "G" => "C",
    "C" => "G",
    "T" => "A",
    "A" => "U"
  }
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna
    |> String.graphemes()
    |> Enum.map(&translate_to_rna/1)
    |> Enum.join("")
  end

  defp translate_to_rna(nucleotide) do
    case Map.fetch(@rna_map, nucleotide) do
      :error -> {:error, "invalid nucleotide"}
      {:ok, result} -> result
    end
  end
end
