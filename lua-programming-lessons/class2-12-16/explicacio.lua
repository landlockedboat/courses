function genericIteration(i, j, state)
  if table[i][j].type == "black" then
    if state.found_black then
      return true
    else
      state.found_black = true
    end
  end
  return false
end


function checkIfBlackHorizontal (startRow, startCol)
  local state = {}
  state.found_black = false
  for i=1,10 do
    found = genericIteration(startRow, i, state)
    if(found) then
      return true
    end
  end
  return false
end

function checkIfBlackHorizontal (startRow, startCol)
  for i=1,10 do
    if table[startRow][i].type == "black" then
      return true
    end
  end
  return false
end
function checkIfBlackHorizontal (startRow, startCol)
  for i=1,10 do
    if table[startRow][i].type == "black" then
      return true
    end
  end
  return false
end
