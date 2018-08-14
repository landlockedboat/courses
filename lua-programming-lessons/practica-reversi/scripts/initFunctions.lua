function initGameBoardBox(y, x)
  local gameBoardBox = {}
  -- Crear una gameBoardBox al punt x, y
  -- ha de tindre com a atributs
  -- diskType (per defecte "nil")
  -- x (centre de la casella a la pantalla)
  -- x = x * (w / amplada del tauler) - la meitat de la amplada de la casella
  -- y = h / alçada del tauler - la meitat de la alçada de la casella
  gameBoardBox.x = x * (w / 8) - (w / 16)
  gameBoardBox.y = y * (h / 8) - (h / 16)
  gameBoardBox.diskType = "nil"

  return gameBoardBox;
end

function initGameBoardBoxes ()
  -- implementa la inicialitzacio de gameBoardBoxes
  -- no cal retornar res, tan sols plenar gameBoardBoxes
  -- gameBoardBoxes[i] -> taula[j] -> elem
  -- hen de fer un for i cridar a initGameBoardBox per als valors i, j del for i assignarho a gameBoardBoxes[i][j]

  for i=1,8 do
    gameBoardBoxes[i] = {}
    for j=1,8 do
      gameBoardBoxes[i][j] = initGameBoardBox(i, j)
    end
  end

  gameBoardBoxes[4][4].diskType = "dark"
  gameBoardBoxes[4][5].diskType = "light"
  gameBoardBoxes[5][4].diskType = "light"
  gameBoardBoxes[5][5].diskType = "dark"
  return gameBoardBoxes
end

function setHint (diskType, x, y)
  if gameBoardBoxes[x][y] == "nil" then
    gameBoardHints[x][y].diskType = diskType
  end
end

function initHints(diskType)
  for i=1,8 do
    gameBoardHints[i] = {}
    for j=1,8 do
      gameBoardHints[i][j] = initGameBoardBox(i, j)
    end
  end
  for i, row in pairs(gameBoardBoxes) do
    for j, v in pairs(row) do
      if(v.diskType == "nil" and gameBoardHints[i][j].diskType == "nil") then
        if(isValidMove(diskType, i, j)) then
          gameBoardHints[i][j].diskType = diskType
        end
      end
    end
  end
end
