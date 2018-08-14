function noSpaces(s)
    return (string.gsub(s, " ", ""))
end

function stringToTable(s)
   local sCharacters = { } 
   for i = 1, #s do
    sCharacters[#sCharacters + 1] = string.match(s, ".", i)  
  end
  return sCharacters
end

function isPalindrom(s) 
  s = noSpaces(s)
  local sIsPalindrom = true
  local sCharacters = stringToTable(s)
  
  for i = 1, (#sCharacters / 2) do
   -- print( sCharacters[i],  sCharacters[#sCharacters - i + 1], sCharacters[i] == sCharacters[#sCharacters - i + 1])
      if sCharacters[i] ~= sCharacters[#sCharacters - i + 1] then
        sIsPalindrom = false
        break
        --return false --also an option
      end
      --]]
  end
  return(sIsPalindrom)
end
