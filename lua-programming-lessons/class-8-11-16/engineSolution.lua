-- Definition of Vec2Dclass
Vec2DClass = {
              x = 0,

              y = 0,

              getModulus =
                function (self)
                  return math.sqrt(self.x^2 + self.y^2)
                end,

              getAngle =
                function (self)
                  return math.atan(self.y / self.x) * 180 / math.pi
                end,

              new =
                function (self, vecx, vecy)
                  local newVec2D = {x = vecx or 0, y = vecy or 0, getModulus, getAngle}
                  newVec2D.getModulus =
                    function (self)
                      return math.sqrt(self.x^2 + self.y^2)
                    end
                  newVec2D.getAngle =
                    function (self)
                      return math.atan(self.y / self.x) * 180 / math.pi
                    end
                  return newVec2D
                end
            }

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
  -- We traverse gameObjectsCollection
  for i = 1, #gameObjectsCollection do
    -- gameObjectsCollection[i] is a game object, so we can look inside its fields:
    if (gameObjectsCollection[i].objectType == "NPC") then
      -- If game object is an enemy, we just add it to enemiesCollection at the end of the table
      -- using the # operator:
      enemiesCollection[#enemiesCollection + 1] = gameObjectsCollection[i]
    end
  end
  return enemiesCollection
end


function getDistance(object1, object2)
  -- This function returns the distance between object1 and object2 using Vec2DClass methods
  -- We define a new vector from object1 to object2, using method "new" of Vec2DClass
  -- Component x of that vector is the substraction of x components of both objects
  -- Component v of that vector is the substraction of v components of both objects
  local vectorObj1_Obj2 = Vec2DClass:new(object2.x - object1.x, object2.y - object1.y)
  -- We just use the "getModulus" method to get the distance bewtween object1 and object2
  return vectorObj1_Obj2:getModulus()
end

function getNearestEnemy(player, enemiesCollection)
  --This function returns the nearest enemy object to player, as an object
  local minDistance = math.huge -- Just a trick using this constant, a VERY high number
  -- We traverse enemiesCollection
  for i = 1, #enemiesCollection do
    -- enemiesCollection[i] is a game object, so we can pass it as an argument
    -- player is a game object passed to the functions, so we can pass it to another function
    if (getDistance(player, enemiesCollection[i]) < minDistance) then
      -- If we found a smaller distance, we replace the mininum distance found...
      -- ... and we replace also the nearest enemy found
      minDistance = getDistance(player, enemiesCollection[i])
      nearestEnemy = enemiesCollection[i]
    end
  end
  return nearestEnemy
end

function createGameObjectsCollection(inputFile)
  --This functions reads lines of a given input file, in the example format "LevelIni.txt"
  -- We define a table with the field names of our game object.
  local gameObjectFields = { "objectType", "objectID", "x", "y" }
   -- We define an empty game objects collection, to store all the game objects read from the file
  local gameObjects = {}
  -- We traverse the hole file with the io.lines() iterator and generic for.
  -- io.lines opens the file and returns a single line of the file every iteration
  for line in io.lines(inputFile) do
    -- We define an empty game object, to store every gameObject read from the file
    local gameObject = {}
    -- We need to find " " (spaces) to separate the different parametrs given in the line file
    -- We define a variable to start the search of " " (space) characters in line
    -- For the first search, we start on the first character of the line
    local startPosition = 1
    -- We define a variable to traverse gameObjectFields table, to access every field name
    local i = 1
    repeat
      -- We define a variable to search the "next" space character starting from startPosition
      local endPosition = string.find(line, " ", startPosition)
      -- The characters delimited from startPosition to endPosition are a field of the game object
      -- We add the field inside the game object variable. The value is read with string.sub function
      -- The field name is read from gameObjectFields table defined previously
      gameObject[gameObjectFields[i]] = string.sub(line, startPosition, endPosition)
      -- To continue searching in the line, we change startPosition to next character of the last
      -- " " (space) found
      startPosition = endPosition + 1
      i = i + 1
    -- We repeat the operation until we do not find another " " (space) character in the line
    until(not(string.find(line, " ", startPosition)))
    -- This code is necessary in order to read the LAST parameter, because the line ends with \n
    -- and NOT with a space
    gameObject[gameObjectFields[i]] = string.sub(line, startPosition, #line)
    -- We add the game object read from the file line at the end of the game objects collection
    gameObjects[#gameObjects + 1] = gameObject
  end
  -- We return the game objects collection
  return gameObjects
end

function saveLevel(outputFile, gameObjectsCollection)
  -- This functions creates an output file to save the level, in the same format as "LevelIni.txt"
  -- Note that the function definition is a bit different from the original. Now gameObjectsCollection is given
  -- as an external parameter
  f = io.open(outputFile, "w")
  -- We traverse gameObjectsCollection with a generic for and iterator ipairs() (as gameObjectsCollection is
  -- a numerical indexed table. We can also traverse it with a classical for, using an index variable
  for k, v in ipairs(gameObjectsCollection) do
    -- v stores a game object read from gameObjectsCollection
    -- we can access its fields in the usual way, using . operator
    -- we don't need to use index k
    f:write(v.objectType .. " " .. v.objectID .. " " .. v.x .. " " .. v.y)
    -- io.write doesn't puts a \n at the end, so we have to put it ath the end of the line:
    f:write("\n")
  end
  f:close()
end

function moveNearestEnemy(player, enemiesCollection)
  --This function MOVES the nearest enemy "enemy" to player "player" returnig a vector with the direction of its movement
  -- (a 2D vector)
  -- The function returns the game object with modified values of x and y
  -- Note that the function definition is a bit different from the original one. Now we don't pass the
  -- nearest enemy as an argument, because we can find it with our previous functions. We need only enemiesCollection
  -- The function now returns a vector with the direction of enemy movement
  -- We find the nearest enemy to the given player
  local enemy = getNearestEnemy(player, enemiesCollection)
  -- We calculate the components of the movement direction
  local xDirection = player.x - enemy.x
  local yDirection = player.y - enemy.y
  -- We create a vector with the calculates direction
  local enemyMovement = Vec2DClass:new(xDirection, yDirection)
  -- Note that getAngle function gives always a positive angle, due its definition in past classes
  -- We can improve our getAngle function looking at the sign of the components.
  return enemyMovement
end
