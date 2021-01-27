def checkPalindrome(inputString) do
  inputString
  |> String.graphemes()
  |> Enum.reverse()
  |> Enum.join()
  |> palindrome?(inputString)
end

defp palindrome?(palindrome, inputString), do: palindrome == inputString
