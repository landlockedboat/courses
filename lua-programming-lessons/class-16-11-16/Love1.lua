print("Hello, this is the LOVE console")

local centerx = 400
local centery = 400
local drawCircle = false
local drawLine = false
local drawHorLine = false

function love.load()
  love.graphics.setBackgroundColor(0, 150, 0)
  
end


function love.update(dt)
  
  
  
  
  
  function love.keypressed(key)
    if key == "space" then
      drawLine = true
    end
  end
  
  function love.mousepressed(x, y, button, isTouch)
      
      centerx = x
      centery = y  
      drawCircle = true
      
      if button == 1 then
        circleType = "fill"
      elseif button == 2 then
        circleType = "line"
      end
  end
  
end


function love.draw()
  
  --[[
  love.graphics.print("Hello, this is the LOVE main window")
  love.graphics.circle("fill", 200, 200, 100, 100)
  
  love.graphics.circle("line", 400, 400, 100, 100)
  --]]
  
  if drawCircle then
    love.graphics.circle(circleType, centerx, centery, 100)
  end
  
  if drawLine then
      love.graphics.line(300, 0, 300, 600)
  end
  
  if love.keyboard.isDown("a") then
      love.graphics.line(0, 300, 600, 300)
  end
  
end
