dofile("objects.lua")
dofile("../fileFunctions.lua")

-- In our level We have the following game objects, defined as tables like this:
gameObject1 = {
              objectType = "player",

              objectID = "player1",

              x = 0,

              y = 0
            }
gameObject2 = {
              objectType = "NPC",

              objectID = "zombie1",

              x = 3,

              y = 4
            }

gameObject3 = {
              objectType = "NPC",

              objectID = "zombie2",

              x = 7,

              y = 20
            }

 gameObject4 = {
              objectType = "player",

              objectID = "player2",

              x = 10,

              y = 15
            }

-- We have also a table filled with ALL game objects in our level
gameObjectsCollection = { gameObject1, gameObject2, gameObject3, gameObject4 }

--
function createEnemiesCollection (gameObjectsCollection)
  --This function returns a table filled ONLY with "NPC" game objects
    local enemiesCollection = {}
  -- Your code here ---
  -- Good Luck! --
    for k,v in pairs(gameObjectsCollection) do
      if (v.objectType == "NPC") then
        enemiesCollection[#enemiesCollection+1] = v
      end
    end

  return enemiesCollection
end


function getDistance(object1, object2)
--[[ This function returns the distance between object1 and object2
using Vec2DClass methods--]]
  local distance
  -- Your code here ---
  -- Good Luck! --
  diffx = math.abs(object1.x - object2.x)
  diffy = math.abs(object1.y - object2.y)

  distance2D = Vec2DClass:new(diffx, diffy);
  distance = distance2D:getModulus();

  return distance
end

function getNearestEnemy(player, enemiesCollection)
  --This function returns the nearest enemy object to player, as an object
  local minDistance = math.huge
  local nearestEnemy = {}
  -- Your code here ---
  -- Good Luck! --
  for k,v in pairs(enemiesCollection) do
    distance = getDistance(player, v)
    if(minDistance > distance) then
      nearestEnemy = v
      minDistance = distance
    end
  end

  return nearestEnemy
end

--[[
[1] -> [zombie1]
k = 1
v = zombie1
[2] -> [zombie2]
k = 2
v = zombie2
[3] -> [zombie3]
k = 3
v = zombie3
[4] -> [zombie4]
k = 4
v = zombie4
]]--

function createGameObjectsCollection(inputFile)
  --This functions reads lines of a given input file, in the example format "LevelIni.txt"
  local gameObjects = {}
  objectAttributes = {"objectType", "objectID", "x", "y"}
  tb = fileToTable (inputFile)

for k,v in pairs (tb) do
    startPosition = 1
    endPosition = 0
    atributeIndex = 1
    local gameObject = {}

    repeat
      endPosition = string.find(v, " ", startPosition)
      gameObject[objectAttributes[atributeIndex]] = string.sub(v, startPosition, endPosition -1)
      startPosition = endPosition + 1
      atributeIndex = atributeIndex + 1
    until(not(string.find(v, " ", startPosition)))

    gameObject[objectAttributes[#objectAttributes]] = string.sub(v, startPosition, #v)
    print (gameObject.objectID)
    gameObjects[#gameObjects +1] = gameObject
  end
  return gameObjects
end

for k,v in pairs (createGameObjectsCollection("LevelIni.lua")) do
  print (v["objectID"])
  end

function saveLevel(outputFile)
  --This functions creates an output file to save the level, in the same format as "LevelIni.txt"
  local gameObject = {}
  local gameObjects = {}
  -- Your code here ---
  -- Good Luck! --

  return gameObjects
end

function moveNearestEnemy(player, enemy, direction)
  local enemyMoved = {}
  --This function MOVES the nearest enemy "enemy" to player "player", changing values of x and y, following a direction given by "direction"
  -- (a 2D vector)
  -- The function returns the game object with modified values of x and y
  -- Your code here ---
  -- Good Luck! --


  return enemyMoved = {}
end
