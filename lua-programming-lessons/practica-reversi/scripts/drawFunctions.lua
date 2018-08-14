function drawBoard()
  -- draws the board like this:
  love.graphics.setColor(255, 255, 255)

  for i = 1, 8 - 1  do
    love.graphics.line(i * w / 8, 0, i * w / 8, h)
  end

  for i = 1, 8 - 1 do
    love.graphics.line(0, i * h / 8, w, i * h / 8)
  end
end

function drawBoxCollection(boxCollection, darkColor, lightColor)
  for rowKey, row in pairs(boxCollection) do
    for colKey, disk in pairs(row) do
      if disk.diskType ~= "nil" then
        if disk.diskType == "light" then
          love.graphics.setColor(lightColor)
        elseif disk.diskType == "dark" then
          love.graphics.setColor(darkColor)
        end
        love.graphics.circle("fill", disk.x, disk.y, 40)
      end

    end
  end
end

function drawGameBoardBoxes ()
  darkColor = {0, 0, 0, 255}
  lightColor = {255, 255, 255, 255}
  drawBoxCollection(gameBoardBoxes, darkColor, lightColor)
end

function drawHintMovement ()
  darkColor = { 0, 0, 0, 128}
  lightColor = { 255, 255, 255, 128}
  drawBoxCollection(gameBoardHints, darkColor, lightColor)
end
