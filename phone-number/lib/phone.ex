defmodule Phone do
  @length 10
  @bad_number String.duplicate("0", @length)

  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    raw
    |> String.trim()
    |> String.replace([" ", ".", "(", ")", "-", "+"], "")
    |> do_number()
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    raw
    |> number()
    |> String.slice(0..2)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw), do: "(#{area_code(raw)}) #{exchange_code(raw)}-#{suffix(raw)}"

  # defp validate_number(number) do
  #   cond do
  #     letters?(number) ->
  #       @bad_number

  #     !valid_code?(String.slice(number, 0..2)) ->
  #       @bad_number

  #     String.length(number) == @length ->
  #       number

  #     String.length(number) == @length + 1 && valid_country_code?(number) ->
  #       remove_country_code(number)

  #     true ->
  #       @bad_number
  #   end
  # end

  defp exchange_code(raw) do
    raw
    |> number()
    |> String.slice(3, 3)
  end

  defp suffix(raw) do
    raw
    |> number()
    |> String.slice(6, 4)
  end

  defp phone_number_valid?(number_string),
    do: String.match?(number_string, ~r/^(1|)[2-9]\d{2}[2-9]\d{6}$/)

  defp do_number(number) do
    if phone_number_valid?(number) do
      String.slice(number, -10..-1)
    else
      @bad_number
    end
  end
end
