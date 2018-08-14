-- Global variables
local spaceShip = {} -- Empty object for space ship
local asteroidsCollection = {} -- Empty table for asteroids collection
local backgroundImageFile -- Empty variable for background image file

local w, h -- Empty variables for window dimensions

local gamePaused = false -- Boolean state variable to control gaume pause
local asteroidsSpawnTime = 1 -- Time interval in SECONDS to spawn a new asteroid in game. This variable DOESN'T change in game 
local asteroidsTimeCounter = 0 -- Time variable to use inside update function (combined with dt) to control asteroids spawn

function newSpaceShip(x, y) 
  -- This function creates a new spaceship object, loads the image file, sets fields and returns it 
  -- Remember that the variable returned is a table
  local spaceShip = {}
  spaceShip.imageFile = love.graphics.newImage("Ship.png")
  spaceShip.x = x
  spaceShip.y = y
  spaceShip.ox = spaceShip.imageFile:getWidth() / 2
  spaceShip.oy = spaceShip.imageFile:getHeight() / 2
  spaceShip.speed = 300
  spaceShip.colliderRadius = spaceShip.imageFile:getWidth() / 2
  return spaceShip
end

function newAsteroid(x, y)
  -- This function creates a new asteorid object, loads the image file, sets fields and returns it
  -- Remember that the variable returned is a table
  local asteroid = {}
  asteroid.imageFile = love.graphics.newImage("Asteroid.png")
  asteroid.x = x
  asteroid.y = y
  asteroid.ox = asteroid.imageFile:getWidth() / 2
  asteroid.oy = asteroid.imageFile:getHeight() / 2
  asteroid.colliderRadius = 80
  asteroid.speed = 150  
  asteroid.colliderRadius = asteroid.imageFile:getWidth() / 2
  return asteroid
end


-- Spawn Functions 

function spawnSpaceShip()
    -- This function sets (x,y) coordinates of a new spaceship, creates it using newSpaceShip function, and returns it
    -- X,Y coordinates are set in order to spawn the ship centered at the center of the window
    -- This function doesn't draw anything
    local spawnX = w / 2
    local spawnY = h / 2
    return newSpaceShip(spawnX, spawnY)
end

function spawnAsteroid()
    -- This function sets (x,y) coordinates of a new asteroid, creates it using newAsteorid function, and returns it
    -- X coordinate is set to a random value from 0 to window width
    -- Y coordinate is set to a negative value out of the window
    -- This function doesn't draw anything
    
    math.randomseed(os.time()) -- Random seed using the system clock, to obtain better random values.
    -- math.random(n1, n2) -- Returns a random number between n1 and n2
    
    local spawnX =  math.random(0, love.graphics.getWidth())
    local spawnY = -100
    return newAsteroid(spawnX, spawnY)   
end

function unspawnAsteroid(i)
  -- This function deletes the asteroid with index [i] from asteroids collection. 
  -- The function doesn't return nothing
  asteroidsCollection[i] = nil
end



function moveAsteroids(dt)
  -- This function traverses the asteroids collection and increases y coordinate of overy asteroid found
  -- Remember that you can find NIL spaces in the collection, so you must use a generic for with pairs()
  -- If after increasing y coordinate, an asteroid is out of the windows, you must delete it from asteroidsCollection
  -- Remember that you have the speed value stored in an asteroid object field
  
  -- We traverse asteroids collection with a generic for
  for index, asteroid in pairs(asteroidsCollection) do
    -- We update the coordinates of every asteroid found
    asteroid.y = asteroid.y + asteroid.speed * dt
    -- We check If asteroid is out of window
    if (asteroid.y - asteroid.oy) > h then 
      -- If so, we unspawn the asteroid by calling the function
      unspawnAsteroid(index)
    end 
  end
end

-- Draw functions

function drawAsteroids()
    -- This function traverses the asteroids collection and draws every asteroid found.
    -- Remember that you can find NIL spaces in the collection, so you must use a generic for with pairs()
    -- Remember coordinates system and center of image
    for index, asteroid in pairs(asteroidsCollection) do
      love.graphics.draw(asteroid.imageFile, asteroid.x - asteroid.ox, asteroid.y - asteroid.oy) 
    end
end


function love.load() 
  
    -- Load background image file
    backgroundImageFile = love.graphics.newImage("background.jpg")
    
    -- Sets w,h to window dimensions
    w, h = love.graphics.getDimensions()
    
    -- Spawn ship
    spaceShip = spawnSpaceShip()
    
end



function love.update(dt)
  -- This function runs every frame
  
  -- We only have to update game objects if game is not paused
  -- So, firts of all we check if game is not paused. 
  if(not(gamePaused)) then
    -- We update our asteroids time counter 
    asteroidsTimeCounter = asteroidsTimeCounter + dt
    
    -- Key events control. We use arrow keys ("right", "left", "up", "down")
    -- We update x,y of the spaceship
    -- We check every key event in pooling mode (love.keyboard.isDown())
    
    if love.keyboard.isDown("right") then
        spaceShip.x = spaceShip.x + spaceShip.speed * dt
    end
    
    if love.keyboard.isDown("left") then
        spaceShip.x = spaceShip.x - spaceShip.speed * dt
    end
    
    if love.keyboard.isDown("up") then
        spaceShip.y = spaceShip.y - spaceShip.speed * dt
    end
    
    if love.keyboard.isDown("down") then
        spaceShip.y = spaceShip.y + spaceShip.speed * dt
    end
    
    -- We check if we we have to spawn a new asteroid (asteroids time counter has reached the preset value)
    if asteroidsTimeCounter > asteroidsSpawnTime then
      -- If so, we spawn a new asteroid and we add it to asteroids collection
      asteroidsCollection[#asteroidsCollection + 1] = spawnAsteroid()
      -- We have to reset our asterois time counter
      asteroidsTimeCounter = 0
    end
    
    -- We check if asteroids collection is not empty
    if #asteroidsCollection > 0 then
      -- If so, we move asteroids by calling the function
      moveAsteroids(dt)
    end
  end
  
  -- Callback function called by LÖVE when a key is pressed
  function love.keypressed(key) 
    -- We check if key pressed is "p" 
    if key == "p" then
      -- If so, we pause the game by setting the global state variable gamePaused
      -- If game is not paused, we have to pause it. If game is paused, we have to continue it
      -- We can toggle the boolean value of the state variable to implement game pause
      gamePaused = not (gamePaused)
    end
  end  
end

function love.draw()
  -- Draw backgorund
  love.graphics.draw(backgroundImageFile)
  
  -- Draw asteroids
  drawAsteroids()
  
  -- Draw space ship
  love.graphics.draw(spaceShip.imageFile, spaceShip.x - spaceShip.ox, spaceShip.y - spaceShip.oy)
  
end
