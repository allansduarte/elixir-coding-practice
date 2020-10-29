defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """

  @rna_map %{
    ?G => ?C,
    ?C => ?G,
    ?T => ?A,
    ?A => ?U
  }
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &translate_to_rna/1)
  end

  defp translate_to_rna(nucleotide) do
    Map.fetch!(@rna_map, nucleotide)
  end
end
