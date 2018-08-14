dofile("scripts/captureFunctions.lua")

function isValidMove(diskType, startRow, startColumn)
  ret = false
  addTokenToGameBoard(diskType, startRow, startColumn)
  ret =  checkCaptures(diskType, startRow, startColumn)
  removeDiskFromGameBoard(startRow, startColumn)
  return ret
end

function getSelectedGameBoardBox(x, y)
  local boxRow, boxColumn

  for r = 1, numRows do
      for c = 1, numColumns do
        if (x >= (c * columnWidth - columnWidth) and (x < (c * columnWidth))) then
          boxColumn = c
        end
        -- We check if (y) is inside the box boundaries
        if (y >= (r * rowHeight  - rowHeight ) and (y < (r * rowHeight))) then
          -- We have to return that row
          boxRow = r
        end
      end
  end


  return boxRow, boxColumn
end
function addTokenToGameBoard(diskType, row, column)
  if (gameBoardBoxes[row][column].diskType == "nil") then
    gameBoardBoxes[row][column].diskType = diskType
  end
end

function removeDiskFromGameBoard(row, column)
  gameBoardBoxes[row][column].diskType = "nil"
end

function validMoves(diskType)
    -- This function returns a table of gameboxes (row, column) that store all the valid movements for diskType
end

function hintMovement(diskType)
    -- This function shows all the valid moves for diskType
    -- It can be called by pressing and holding a key ("H" for example), to help the player
end

function isWinner()
    -- This function returns if there is a winner.
    -- Remember that the game ends when there are no valid moves for both players.
    -- If the game ends, function counts diskTypes of both players and returns the winner
    -- If the game can continue, the function returns nil
end
