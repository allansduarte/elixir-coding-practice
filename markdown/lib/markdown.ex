defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join()
    |> enclose_with_list_tag()
  end

  def process(row) do
    case String.first(row) do
      "#" ->
        row
        |> parse_header_md_level()
        |> enclose_with_header_tag()

      "*" ->
        row
        |> parse_list_item_md_level()
        |> enclose_with_list_item_tag()

      _ ->
        row
        |> String.split()
        |> enclose_with_paragraph_tag()
    end
  end

  defp parse_header_md_level(header) do
    [markdown | text] = String.split(header)
    {to_string(String.length(markdown)), Enum.join(text, " ")}
  end

  defp enclose_with_list_item_tag(list), do: "<li>" <> parse_list_item_md_level(list) <> "</li>"

  defp parse_list_item_md_level(list) do
    list
    |> String.trim_leading("* ")
    |> String.split()
    |> join_words_with_tags()
  end

  defp enclose_with_header_tag({heading_level, heading_text}) do
    "<h" <> heading_level <> ">" <> heading_text <> "</h" <> heading_level <> ">"
  end

  defp enclose_with_paragraph_tag(tags) do
    "<p>#{join_words_with_tags(tags)}</p>"
  end

  defp join_words_with_tags(tags) do
    Enum.join(Enum.map(tags, &replace_md_with_tag/1), " ")
  end

  defp replace_md_with_tag(tag) do
    tag
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md(tag) do
    cond do
      tag =~ ~r/^#{"__"}{1}/ -> String.replace(tag, ~r/^#{"__"}{1}/, "<strong>", global: false)
      tag =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(tag, ~r/_/, "<em>", global: false)
      true -> tag
    end
  end

  defp replace_suffix_md(tag) do
    cond do
      tag =~ ~r/#{"__"}{1}$/ -> String.replace(tag, ~r/#{"__"}{1}$/, "</strong>")
      tag =~ ~r/[^#{"_"}{1}]/ -> String.replace(tag, ~r/_/, "</em>")
      true -> tag
    end
  end

  defp enclose_with_list_tag(list) do
    String.replace_suffix(
      String.replace(list, "<li>", "<ul>" <> "<li>", global: false),
      "</li>",
      "</li>" <> "</ul>"
    )
  end
end
