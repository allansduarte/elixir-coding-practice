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
    |> Enum.map_join(&process_lines/1)
    |> process_tags()
    |> enclose_with_list_tag()
  end

  defp process_lines("#" <> str), do: parse_header(str, 1)

  defp process_lines("*" <> str), do: "<li>#{String.trim(str)}</li>"

  defp process_lines(str), do: "<p>#{str}</p>"

  defp parse_header(" " <> str, h_level), do: "<h#{h_level}>#{String.trim(str)}</h#{h_level}>"
  defp parse_header("#" <> str, h_level), do: parse_header(str, h_level + 1)

  defp process_tags(str) do
    str
    |> parse_bold_tags()
    |> parse_italic_tags()
  end

  defp parse_bold_tags(str), do: String.replace(str, ~r/__([^_]+)__/, "<strong>\\1</strong>")

  defp parse_italic_tags(str), do: String.replace(str, ~r/_([^_]+)_/, "<em>\\1</em>")

  defp enclose_with_list_tag(str) do
    str
    |> close_initial_list_tag()
    |> close_end_list_tag()
  end

  defp close_initial_list_tag(str), do: String.replace(str, "<li>", "<ul><li>", global: false)

  defp close_end_list_tag(str), do: String.replace_suffix(str, "</li>", "</li></ul>")
end
