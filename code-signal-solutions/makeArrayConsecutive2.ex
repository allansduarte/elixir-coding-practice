def makeArrayConsecutive2(statues) do
  sorted_statues = Enum.sort(statues)
  Enum.at(sorted_statues, Enum.count(sorted_statues) - 1) - Enum.at(sorted_statues, 0) + 1 - Enum.count(sorted_statues)
end
