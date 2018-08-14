-- Global variables (defined as local in chunk)
-- Remember that we don't need to define variables in Lua befor using it (except in the case of tables)
-- We just define them here because they will be used as global variables (external to all functions)

local tokenType
local row = 1
local column = 1
local winnerToken = nil
local winnerType = nil
local winnerSound
local winnerSoundPlayed = false
local numRows
local numColumns
local w, h
local rowHeight, columnWidth
local tokenRadius


local gameBoardBoxes = {}

-- Game board table (also called game board map). The main variable of the code.
-- It will be a [rows]x[columns] table.
-- For instance, in our Tic Tac Toe game, it will be a 3x3 table:
--[[
local gameBoardBoxes = {
                        { {}, {}, {} }, -- Row 1
                        { {}, {}, {} }, -- Row 2
                        { {}, {}, {} }  -- Row 3
                        }
--]]


---[[
function initGameBoardBoxes()
  -- This function initializes the game board table
  -- Remember that game board table is stored in an external variable, BUT it has to be declared
  -- because it is a table
  -- gameBoardBoxes[r][c].x = x center of the box
  -- gameBoardBoxes[r][c].y = y center of the box
  -- gameBoardBoxes[r][c].tokenType = nil -- no token in the box
  -- We calculate x,y with columnWidth and rowHeight

  -- When the function is called, we want the result to be something like that:
  --[[
local gameBoardBoxes = {
  { {x = 100, y = 100, tokenType = nil}, {x = 300, y = 100, tokenType = nil}, {x = 500, y = 100, tokenType = nil} }, -- Row 1
  { {x = 100, y = 300, tokenType = nil}, {x = 300, y = 300, tokenType = nil}, {x = 500, y = 300, tokenType = nil} }, -- Row 2
  { {x = 100, y = 500, tokenType = nil}, {x = 300, y = 500, tokenType = nil}, {x = 500, y = 500, tokenType = nil} }, -- Row 3
}
--]]

  -- Loop to traverse rows
  for r = 1, numRows do
    gameBoardBoxes[r] = {}
    -- Loop to traverse columns
    for c = 1, numColumns do
      gameBoardBoxes[r][c] = {}  
      -- We set x,y coordinates of the center of every board box
      -- We calculate x,y with columnWidth and rowHeight
      gameBoardBoxes[r][c].x = (c * columnWidth) - (columnWidth / 2)
      gameBoardBoxes[r][c].y = (r * rowHeight) - (rowHeight / 2)
      gameBoardBoxes[r][c].tokenType = nil
      --print(gameBoardBoxes[r][c].x, gameBoardBoxes[r][c].y, gameBoardBoxes[r][c].tokenType)
    end
  end
end
    --]]

function getSelectedGameBoardBox(x, y)
  -- This function returns the selected box given by x,y (mouse position)
  -- We use the center of the box (stored in gameBoardBoxes[r][c].x, gameBoardBoxes[r][c].y) and
  -- columnWidth and rowHeight (external variables)

  -- This is the hardcode mode, just to see what type of result we expect
  -- Do'nt do that, use loops!!!
  --[[
  if (x < 200) then
    column = 1
  elseif (x > 200) and (x < 400) then
    column = 2
  elseif (x > 400) then
    column = 3
  end
  if (y < 200) then
    row = 1
  elseif (y > 200) and (y < 400) then
    row = 2
  elseif (y > 400) then
    row = 3
  end
  --]]


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


function drawGameBoardGrid()
  -- This function draws board grid on screen
  -- We calculate positions of grid lines with w, h, columnWidth, rowHeight

  -- We set draw color to white
  love.graphics.setColor(255, 255, 255)
  -- We set line width to 2 px
  love.graphics.setLineWidth(2)

  -- Loop fot horizontal grid lines
  for i = 1, numRows - 1 do
      love.graphics.line(0, i * rowHeight, w, i * rowHeight)
  end
  -- Loop for vertical grid lines
  for i = 1, numColumns - 1 do
      love.graphics.line(i * columnWidth, 0, i * columnWidth, h)
  end

  --love.graphics.line(200, 0, 200, 600)
  --love.graphics.line(400, 0, 400, 600)
  -- Horizontal grid separators
  -- love.graphics.line(0, 200, 600, 200)
  -- love.graphics.line(0, 400, 600, 400)
end

function drawGameBoardBoxes()
  -- This function draw tokens on game board
  -- Game board map is stored in gameBoardBoxes table.
  -- We have to traverse the table and draw a token if found
  -- Remember that gameBoardBoxes[r][c].tokenType stores the token ('o', 'x', 'nil') in that particular box
  -- Remember that gameBoardBoxes[r][c].x, gameBoardBoxes[r][c].y stores the center of the box

-- Code for instruction (at the beginning)
--  if tokenType == 'o' then
--    love.graphics.setColor(255, 255, 255)
--    love.graphics.circle("line", 100, 100, 80)
--  elseif tokenType == 'x' then
--    love.graphics.setColor(255, 255, 255)
--    love.graphics.setLineWidth(2)
--    love.graphics.line(20, 20, 180, 180)
--    love.graphics.line(20, 180, 180, 20)
--  end

  -- Loop to traverse rows
  for r = 1, numRows do
    -- Loop to traverse column
    for c = 1, numColumns do
      -- If token is not nil
      if(gameBoardBoxes[r][c].tokenType) then
        -- We define variables to store the center of the box (x,y)
        -- This variables are not necessary but they will make further code more clear
        local centerx = gameBoardBoxes[r][c].x
        local centery = gameBoardBoxes[r][c].y
        -- If token is 'o'
        if gameBoardBoxes[r][c].tokenType == 'o' then
          -- We draw a white circle, centered on the box
          -- Remember that we have an external variable with the radius
          love.graphics.setColor(255, 255, 255)
          love.graphics.circle("line", centerx, centery, tokenRadius )
        -- If token is 'x'
        elseif gameBoardBoxes[r][c].tokenType == 'x' then
          -- We draw a white X, centered on the box
          -- Remember that we have an external variable with the "radius"
          love.graphics.setColor(255, 255, 255)
          love.graphics.setLineWidth(2)
          love.graphics.line(centerx - tokenRadius, centery - tokenRadius, centerx + tokenRadius, centery + tokenRadius)
          love.graphics.line(centerx + tokenRadius, centery - tokenRadius, centerx - tokenRadius, centery + tokenRadius)
        end
      end
    end
  end
end





function addTokenToGameBoard(tokenType, row, column)
  -- This function stores the tokenType token to the game board box given by row, column
  -- Remember that we use the external table gameBoardBoxes to store the game board map

  -- If token in (row, column) is nil
  if (not(gameBoardBoxes[row][column].tokenType)) then
    -- We just put the tokenType to the field
    gameBoardBoxes[row][column].tokenType = tokenType
  end
end


function checkWinner()
  -- This function returns if ther is a winner, and the winner token type (o / x)
  -- We define a variable to return if there is a winner
  local winnerToken = nil
  -- We define an horizontal counter to count same token types in a row
  local tokenHorCounter
  -- We traverse rows
  for r = 1, numRows do
    -- Every loop, we have to set horizontal token counter to 0
    tokenHorCounter = 0
    -- We check if the we found a token in the first box of the row
    -- If so, we increase the horizontal counter
    if gameBoardBoxes[r][1].tokenType then tokenHorCounter = 1 end
    -- We traverse columns (from 1 to columns - 1 to avoid errors in last box)
    for c = 1, numColumns - 1 do
      -- We check if there are tokens in box [r][c] AND in the next box [r][c+1]
      if gameBoardBoxes[r][c].tokenType and gameBoardBoxes[r][c + 1].tokenType then
        -- If so, we check if tokens are of the same type
        if gameBoardBoxes[r][c].tokenType == gameBoardBoxes[r][c + 1].tokenType then
          -- If so, we increase the horizontal counter
          tokenHorCounter = tokenHorCounter + 1
          -- We check if the horizontal counter rised 3 (3 tokens in the same row)
          if tokenHorCounter == 3 then
            -- If sow, we have a winner.
            -- We set variables to return, and we return them
            winnerToken = gameBoardBoxes[r][c].tokenType
            winnerType = "row"
            return winnerToken, winnerType
          end
        end
      end
    end
    -- Debug code
    -- print("row " .. r .. " = " .. tokenHorCounter .. " matching tokens")
  end


  -- We define an vertical counter to count same token types in a column
  local tokenVerCounter
  -- We traverse columns
  for c = 1, numColumns do
    -- Every loop, we have to set vertical token counter to 0
    tokenVerCounter = 0
    -- We check if the we found a token in the first box of the column
    -- If so, we increase the vertical counter
    if gameBoardBoxes[1][c].tokenType then tokenVerCounter = 1 end
    -- We traverse rows (from 1 to rows - 1 to avoid errors in last box)
    for r = 1, numRows - 1 do
      -- We check if there are tokens in box [r][c] AND in the next box [r][c+1]
      if gameBoardBoxes[r][c].tokenType and gameBoardBoxes[r + 1][c].tokenType then
        -- If so, we check if tokens are of the same type
        if gameBoardBoxes[r][c].tokenType == gameBoardBoxes[r + 1][c].tokenType then
          -- If so, we increase the vertical counter
          tokenVerCounter = tokenVerCounter + 1
          -- We check if the vertical counter rised 3 (3 tokens in the same column)
          if tokenVerCounter ==3 then
            -- If sow, we have a winner.
            -- We set variables to return, and we return them
            winnerToken = gameBoardBoxes[r][c].tokenType
            winnerType = "column"
            return winnerToken, winnerType
          end
        end
      end
    end
    -- Debug code
    -- print("column " .. c .. " = " .. tokenVerCounter .. " matching tokens")
  end

  -- Check diagonal from upper left corner [1,1]
  local tokenLeftDiagCounter = 0
  if gameBoardBoxes[1][1].tokenType then tokenLeftDiagCounter = 1 end
  for d = 1, 2 do
      if gameBoardBoxes[d][d].tokenType and gameBoardBoxes[d + 1][d + 1].tokenType then
        if gameBoardBoxes[d][d].tokenType == gameBoardBoxes[d + 1][d + 1].tokenType then
          tokenLeftDiagCounter = tokenLeftDiagCounter + 1
          if tokenLeftDiagCounter == 3 then
            winnerToken = gameBoardBoxes[d][d].tokenType
            winnerType = "leftdiagonal"
            return winnerToken, winnerType
          end
        end
    end
    -- Debug code
    -- print("left diagonal = " .. tokenLeftDiagCounter .. " matching tokens")
  end

  -- Check diagonal from upper right corner [1,3]
  local tokenRightDiagCounter = 0
  if gameBoardBoxes[1][3].tokenType then tokenRightDiagCounter = 1 end
  local dj = 3
  for di = 1, 2 do
      if gameBoardBoxes[di][dj].tokenType and gameBoardBoxes[di + 1][dj - 1].tokenType then
        if gameBoardBoxes[di][dj].tokenType == gameBoardBoxes[di + 1][dj - 1].tokenType then
          tokenRightDiagCounter = tokenRightDiagCounter + 1
          if tokenRightDiagCounter == 3 then
            winnerToken = gameBoardBoxes[di][dj].tokenType
            winnerType = "rightdiagonal"
            return winnerToken, winnerType
          end
        end
        dj = dj - 1
      end
      -- Debug code
      -- print("right diagonal = " .. tokenRightDiagCounter .. " matching tokens")
  end
  -- Debug code
  --print(tokenHorCounter, tokenVerCounter, tokenLeftDiagCounter, tokenRightDiagCounter, winnerToken)
end

--[[ This version of the function starts on startRow, startColumn, and only checks the row and the column of the given tokentipe
function checkWinner(startRow, startColumn)
  local winnerToken = nil

  local tokenHorCounter = 1
  for c = 1, 2 do
    if gameBoardBoxes[startRow][c].tokenType and gameBoardBoxes[startRow][c + 1].tokenType then
      if gameBoardBoxes[startRow][c].tokenType == gameBoardBoxes[startRow][c + 1].tokenType then
        tokenHorCounter = tokenHorCounter + 1
        if tokenHorCounter ==3 then
          winnerToken = gameBoardBoxes[startRow][c].tokenType
          winnerType = "row"
          --print(tokenHorCounter, tokenVerCounter, winnerToken)
          return winnerToken, winnerType
        end
      end
    end
  end

  local tokenVerCounter = 1
  for r = 1, 2 do
    if gameBoardBoxes[r][startColumn].tokenType and gameBoardBoxes[r + 1][startColumn].tokenType then
      if gameBoardBoxes[r][startColumn].tokenType == gameBoardBoxes[r + 1][startColumn].tokenType then
        tokenVerCounter = tokenVerCounter + 1
        if tokenVerCounter ==3 then
          winnerToken = gameBoardBoxes[r][startColumn].tokenType
          winnerType = "column"
          return winnerToken, winnerType
        end
      end
    end
  end

  local tokenLeftDiagCounter = 0
  if gameBoardBoxes[1][1].tokenType then tokenLeftDiagCounter = 1 end
  -- Check diagonal from upper left corner [1,1]
  for r = 1, 2 do
    for c = 1, 2 do
      if gameBoardBoxes[r][c].tokenType and gameBoardBoxes[r + 1][c + 1].tokenType then
        if gameBoardBoxes[r][c].tokenType == gameBoardBoxes[r + 1][c + 1].tokenType then
          tokenLeftDiagCounter = tokenLeftDiagCounter + 1
          if tokenLeftDiagCounter == 3 then
            winnerToken = gameBoardBoxes[r][c].tokenType
            winnerType = "leftdiagonal"
            return winnerToken, winnerType
          end
        end
      end
    end
  end


  local tokenRightDiagCounter = 0
  if gameBoardBoxes[1][3].tokenType then tokenRightDiagCounter = 1 end
  -- Check diagonal from upper right corner [1,3]
  for r = 1, 2 do
    for c = 3, 2, -1 do
      if gameBoardBoxes[r][c].tokenType and gameBoardBoxes[r + 1][c - 1].tokenType then
        if gameBoardBoxes[r][c].tokenType == gameBoardBoxes[r + 1][c - 1].tokenType then
          tokenRightDiagCounter = tokenRightDiagCounter + 1
          if tokenRightDiagCounter == 3 then
            winnerToken = gameBoardBoxes[r][c].tokenType
            winnerType = "rightdiagonal"
            return winnerToken, winnerType
          end
        end
      end
    end
  end
  print(tokenHorCounter, tokenVerCounter, tokenLeftDiagCounter, tokenRightDiagCounter, winnerToken)


end
--]]
function restartGame()
    -- This function restarts the game, by doing the following actions:
    -- Sets global variables row, column to default value (1)
    row = 1
    column = 1
    -- Sets winnerToken variable to nil
    winnerToken = nil
    -- Sets winnerType ("row", "column", "diag" to nil)
    winnerType = nil
    -- Sets winnerSoundPlayed to false
    winnerSoundPlayed = false
    -- Initializes the game board table
    initGameBoardBoxes()
    -- Stops playing winner sound
    winnerSound:stop()
end

function drawWinnerLine(row, column, winnerType)
  --[[ Debug code
  print ("row = " .. row .. "column = " .. column)
  --]]
  local startx, starty, endx, endy

  if winnerType == "row" then
    startx = gameBoardBoxes[row][1].x - tokenRadius
    endx = gameBoardBoxes[row][3].x + tokenRadius
    starty = gameBoardBoxes[row][1].y
    endy = starty
  elseif winnerType == "column" then
    startx = gameBoardBoxes[1][column].x
    endx = startx
    starty = gameBoardBoxes[1][column].y - tokenRadius
    endy = gameBoardBoxes[3][column].y + tokenRadius
  elseif winnerType == "leftdiagonal" then
    startx = gameBoardBoxes[1][1].x - tokenRadius
    starty = gameBoardBoxes[1][1].y - tokenRadius
    endx = gameBoardBoxes[3][3].x + tokenRadius
    endy = gameBoardBoxes[3][3].y + tokenRadius
  elseif winnerType == "rightdiagonal" then
    startx = gameBoardBoxes[1][3].x + tokenRadius
    starty = gameBoardBoxes[1][3].y - tokenRadius
    endx = gameBoardBoxes[3][1].x - tokenRadius
    endy = gameBoardBoxes[3][1].y + tokenRadius
  end
  love.graphics.setLineWidth(5)
  love.graphics.setColor(255, 0, 0)
  love.graphics.line(startx, starty, endx, endy)
end

function drawWinnerText(winnerToken)
  -- We set graphics color as red with a 50% transparency
  love.graphics.setColor(255, 0, 0, 125)
  -- We draw a rectangle in the center of the window
  love.graphics.rectangle("fill", columnWidth / 2, rowHeight * 1.1, 2 * columnWidth , rowHeight * 0.8 )

  -- We set graphics color as white
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(love.graphics.newFont(tokenRadius))
  love.graphics.print("Winner: " .. winnerToken, (columnWidth / 2) * 1.1, rowHeight * 1.2)
end




-- Game Loop Functions

function love.load()
  -- We get window dimensions
  w, h = love.graphics.getDimensions()
  -- We set number of rows and columns of game board
  numRows = 3
  numColumns = 3
  -- We set row height and column width of game board
  rowHeight = h / numRows
  columnWidth = w / numColumns
  -- We set the token radius as 80% of column width
  tokenRadius = columnWidth * 0.4

  -- We initialize the game board table
  initGameBoardBoxes()

  -- We set the background color as soft green
  love.graphics.setBackgroundColor(0, 150, 0)

  -- We load the FX winner sound file, and store it in a variable
  winnerSound = love.audio.newSource("Winning-sound-effect.mp3")

end

function love.update(dt)
  -- Callback function of mouse pressed event
  -- Function is called by LOVE engine, passing the mouse position and the pressed button
  function love.mousepressed(x, y, button, isTouch)
      -- We only process mouse press events if there is NO winner
      -- We check it with the winnerToken variable
      if winnerToken == nil then
        row, column = getSelectedGameBoardBox(x, y)
        print(row, column)
        if button == 1 then
          tokenType = 'o'
        elseif button == 2 then
          tokenType = 'x'
        end
        -- We add the token to game board
        addTokenToGameBoard(tokenType, row, column)
        -- We check if ther is a winner
        winnerToken, winnerType = checkWinner(row, column)
      end
  end

  -- Callback function of keyboard pressed event
  -- Function is called by LOVE engine, passing the pressed key
  -- We can restart the game at any moment
  function love.keypressed(key)
    -- If 'Enter' restart the game
    if key == "return" then
      restartGame()
    end
  end

end

function love.draw()
  -- We draw game board grid by calling function
  drawGameBoardGrid()

  -- We draw game the board tokens by calling function
  drawGameBoardBoxes()

  -- If there is a winner, we draw winner line and winner text
  if winnerToken then
    drawWinnerLine(row, column, winnerType)
    drawWinnerText(winnerToken)
    -- We play FX winner sound
    if not(winnerSoundPlayed) then
      winnerSound:play()
      winnerSoundPlayed = true
    end
  end

end
