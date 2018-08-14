function getDrawHint()
  local drawHint = false
  if love.keyboard.isDown("h") then
    drawHint = true;
  end
  return drawHint
end
