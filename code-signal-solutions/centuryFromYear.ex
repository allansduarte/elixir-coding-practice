def centuryFromYear(year) when year >= 1 and year <= 2005 do
  Float.ceil(year / 100)
end
