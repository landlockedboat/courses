-- Rename to main.lua to execute with LOVE

local w, h
local drawGrid

function drawGameBoardGrid(rows, columns)
  love.graphics.setLineWidth(5)
  
  --[[
  love.graphics.line(200, 0, 200, 600)
  love.graphics.line(400, 0, 400, 600)
  love.graphics.line(0, 200, 600, 200)
  love.graphics.line(0, 400, 600, 400)
  --]]
  --[[
  love.graphics.line(w / 3, 0, w / 3, h)
  love.graphics.line(2 * w / 3, 0, 2 * w / 3, h)
  love.graphics.line(0, h / 3, w, h / 3)
  love.graphics.line(0, 2 * h / 3, w, 2 * h / 3)
  --]]
  
  for i = 1, columns - 1  do
    love.graphics.line(i * w / columns, 0, i * w / columns, h)
  end
  
  for i = 1, rows - 1 do
    love.graphics.line(0, i * h / rows, w, i * h / rows)
  end
end


function love.load()
  print("Hello, this is the debug console")
  
  w, h = love.graphics.getDimensions()
  
  print (w, h)
  
  love.graphics.setBackgroundColor(0, 150, 0)
  
end


function love.update(dt)
  --[[
  if love.keyboard.isDown("space") then
    drawGrid = true
  end
  --]]
  
  function love.keypressed(key)
    if key == "space" then
      drawGrid = true
    end
  end
  
  --mousex, mousey = love.mouse.getPosition()
  --print(mousex, mousey)
  
  if love.mouse.isDown(2) then
    mousex, mousey = love.mouse.getPosition()
    print(mousex, mousey)
  end
    
end


function love.draw()
  if drawGrid then
    drawGameBoardGrid(10, 5)
  end
end
