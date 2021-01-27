def checkPalindrome(input_string) do
  input_string
  |> String.graphemes()
  |> Enum.reverse()
  |> Enum.join()
  |> palindrome?(input_string)
end

defp palindrome?(palindrome, input_string), do: palindrome == input_string
