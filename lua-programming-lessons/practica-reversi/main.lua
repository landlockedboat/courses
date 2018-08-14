dofile("scripts/reversiFunctions.lua")
dofile("scripts/initFunctions.lua")
dofile("scripts/drawFunctions.lua")
dofile("scripts/inputFunctions.lua")


w, h = 0, 0
numRows, numColumns = 8,8
-- Brevity is the soul of wit
-- Dont repeat yourself
gameBoardBoxes = {}

isHintsInit = false
gameBoardHints = {}

local black_player, white_player = "dark", "light"

local current_player = black_player
local init, choosing_play, game_over = 1, 2, 3
local state = init

local drawHint = false;
-- löve

function love.load()
  w, h = love.graphics.getDimensions()
  love.graphics.setBackgroundColor(0, 150, 0)
  -- 8 x 8 board initialised with two white disks
  -- and two black ones at the center
  -- we also have information about the "center"
  -- of the board boxes in screen coordinates
  gameBoardBoxes = initGameBoardBoxes()
  state = choosing_play
end

function love.update(dt)
  drawHint = getDrawHint()
  if not isHintsInit then
    gameBoardHints = {}
    initHints(current_player)
    isHintsInit = true
  end
end

function love.mousepressed(x, y, button, istouch)
  if(state == choosing_play and button == 'l') then

    boardy = math.ceil(y / math.ceil(h/numRows))
    boardx = math.ceil(x / math.ceil(w/numColumns))
    print(gameBoardHints[boardy][boardx].diskType)

    if(gameBoardHints[boardy][boardx].diskType == current_player) then
      addTokenToGameBoard(current_player, boardy, boardx)
      makeCaptures(current_player, boardy, boardx)
      current_player = getReverseDiskType(current_player)
      isHintsInit = false
    end

    -- if(isValidMove(current_player, boardy, boardx)) then
    --   checkCaptures(current_player, boardy, boardx)
    --   current_player = getReverseDiskType(current_player)
    -- end
  end

end

function love.draw()
  drawBoard()
  if(drawHint) then
    drawHintMovement()
  end
  drawGameBoardBoxes()
end
