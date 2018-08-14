function getReverseDiskType(diskType)
  -- This function returns the opposite disk type to diskType
  -- If disktype is "light", it returns "dark"
  -- if disktype is "dark", it returns "light"
  
end




function checkHorizontalCapture(diskType, startRow, startColumn)
    -- This function returns if it's possible to make an horizontal capture in the row given by startrow
    -- Remember that a capture movement is possible if there are opposite disk types bewteen two own disk types
    -- If an horizontal capture is possible, the function returns: 
      -- True
      -- start game box (row, column) of the capture
      -- end game box (row, column) of the capture
    -- If there is no horizontal capture in the row, the function returns 
      -- False
end

function checkVerticalCapture(diskType, startRow, startColumn)
    -- This function returns if it's possible to make a vertical capture in the column given by startColumn
    -- Remember that a capture movement is possible if there are opposite disk types bewteen two own disk types
    -- If a vertical capture is possible, the function returns: 
      -- True
      -- start game box (row, column) of the capture
      -- end game box (row, column) of the capture
    -- If there is no vertical capture in the column, the function returns 
      -- False
end

function checkDiagonalCapture(diskType, startRow, startColumn)
    -- This function returns if it's possible to make a diagonl capture in the column given by startRow, startColumn
    -- Remember that a capture movement is possible if there are opposite disk types bewteen two own disk types
    -- If a vertical capture is possible, the function returns: 
      -- True
      -- start game box (row, column) of the capture
      -- end game box (row, column) of the capture
    -- If there is no diagonal capture in the column, the function returns 
      -- False
end

function isValidMove(diskType, startRow, startColumn)
    -- This function returns if is a diskType placed in (startRow, startColumn) is a valid move. 
    -- Remember that a move is valid only if it causes capture of opposite disks. 
    -- Use older functions to check it
end
 
function removeDiskFromGameBoard(row, column)
    -- This function removes the disk placed in (row, column) of the game gameboard
    -- The function doesn't return nothing
    -- You can remove a disk from the game board when placed before (with the addToken function) but further checked that it's not a valid move
    -- If you do so, DON'T draw the gameboard with the new disk before checking valid moves
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

