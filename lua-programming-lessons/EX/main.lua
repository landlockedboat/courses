-- Global variables
local backgroundImageFile -- Empty variable for background image file
local spaceShip = {} -- Empty object for space ship object
local asteroidsCollection = {} -- Empty table for asteroids collection
local bulletsCollection = {} -- Empty table for bullets collection
local starsCollection = {} -- Empty table for stars collection
local shield = nil -- Empty variable for shield object
local explosionCollection = {}

local asteroidMaxSpeed = 100 -- Numeric cariable to set initial asteroid speed
local updateAsteroidSpeed = false -- Boolean variable to allow the update of asteroid speed

local w, h -- Empty variables for window dimensions

local gamePaused = false -- Boolean state variable to control gaume pause
local asteroidsSpawnTime = 1 -- Time interval in SECONDS to spawn a new asteroid in game. This variable DOESN'T change in game 
local asteroidsTimeCounter = 0 -- Time variable to use inside update function (combined with dt) to control asteroids spawn

local starsSpawnTime = 20 -- Time interval in SECONDS to spawn a new star in game. This variable DOESN'T change in game 
local starsTimeCounter = 0 -- Time variable to use inside update function (combined with dt) to control stars spawn

local shieldSpawnedTime = 7 -- Time interval in SECONDS to have the shield spawned in game. This variable DOESN'T change in game 
local shieldTimeCounter = 0 -- Time variable to use inside update function (combined with dt) to control shield spawn


local blinkingShieldTimeCounter = 0 -- Time variable to use inside update function (combined with dt) to control shield blinking 
local toggleDrawShield = true -- Boolean variable to control shiled blinking
local shieldAnimationTime = 0.2 -- Time variable to "animate" blinking shield 
local shieldFixedTime = 4 -- Time interval when the shield is fixed (not animated)

local hud = {
  imageFile = love.graphics.newImage("HUD.png"),
  font = love.graphics.newFont("neuro.ttf", 50),
  points = 0,
  lives = 3
  }

function newSpaceShip(x, y) 
  -- This function creates a new spaceship object, loads the image file, sets fields and returns it 
  -- Remember that the variable returned is a table
  local spaceShip = {}
  spaceShip.imageFile = love.graphics.newImage("Ship.png")
  spaceShip.ox = spaceShip.imageFile:getWidth() / 2
  spaceShip.oy = spaceShip.imageFile:getHeight() / 2
  spaceShip.x = x 
  spaceShip.y = y 
  spaceShip.speed = 300
  spaceShip.colliderRadius = spaceShip.imageFile:getWidth() / 2
  return spaceShip
end

function newAsteroid(x, y, speed)
  -- This function creates a new asteorid object, loads the image file, sets fields and returns it
  -- Remember that the variable returned is a table
  
  -- Note that this function changed: 
    -- adding a new parameter to the funtcion definition, the speed of the new asteroid
    -- adding a new field to asteroid object: health points of the asteroid
  local asteroid = {}
  asteroid.imageFiles = {"Asteroid.png", "Asteroid01.png", "Asteroid02.png"}
  asteroid.imageFile = love.graphics.newImage(asteroid.imageFiles[1])
  asteroid.currentImageFile = 1
  asteroid.x = x
  asteroid.y = y
  asteroid.ox = asteroid.imageFile:getWidth() / 2
  asteroid.oy = asteroid.imageFile:getHeight() / 2
  asteroid.speed = speed or 100  
  asteroid.colliderRadius = asteroid.imageFile:getWidth() / 2
  asteroid.healthPoints = 3
  return asteroid
end

function newStar(x, y)
    local star = {}
    star.imageFile = love.graphics.newImage("Star.png")
    star.x = x
    star.y = y
    star.ox = star.imageFile:getWidth() / 2
    star.oy = star.imageFile:getHeight() / 2
    star.speed = 100
    star.colliderRadius =  star.imageFile:getWidth() / 2
    return star
end


function newBullet(x, y)
    local bullet = {}
    bullet.imageFile = love.graphics.newImage("Bullet.png")
    bullet.x = x
    bullet.y = y
    bullet.ox = bullet.imageFile:getWidth() / 2
    bullet.oy = bullet.imageFile:getHeight() / 2
    bullet.speed = 400
    bullet.colliderRadius =  bullet.imageFile:getWidth() / 2
    return bullet
end


function newShield(x, y)
  local shield = {}
    shield.imageFile = love.graphics.newImage("Shield.png")
    shield.frames = {}
    shield.frames[0] = love.graphics.newQuad(0, 0, 168, 168, shield.imageFile:getDimensions())
    shield.currentFrame = 0
    shield.activeFrame = shield.frames[shield.currentFrame]
    shield.x = x
    shield.y = y
    shield.ox = 84
    shield.oy = 84
    shield.currentFrameTimeCounter = 0
    return shield
end

function newExplosion(x, y)
  local explosion = {}
    explosion.imageFile = love.graphics.newImage("Explosion.png")
    explosion.frames = {}
    explosion.frames[0] = love.graphics.newQuad(0, 0, 168, 168, explosion.imageFile:getDimensions())
    explosion.frames[1] = love.graphics.newQuad(0, 0, 168, 168, explosion.imageFile:getDimensions())
    explosion.frames[2] = love.graphics.newQuad(0, 0, 168, 168, explosion.imageFile:getDimensions())
    explosion.frames[3] = love.graphics.newQuad(0, 0, 168, 168, explosion.imageFile:getDimensions())
    explosion.currentFrame = 0
    explosion.totalFrames = 4
    explosion.activeFrame = explosion.frames[explosion.currentFrame]
    explosion.x = x
    explosion.y = y
    explosion.ox = 84
    explosion.oy = 84
    explosion.currentFrameTimeCounter = 0
    return explosion
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

function unspawnSpaceShip()
  -- This function deletes spacheship object
  spaceShip = nil
end


function spawnAsteroid()
    -- This function sets (x,y) coordinates of a new asteroid, creates it using newAsteorid function, and returns it
    -- X coordinate is set to a random value from 0 to window width
    -- Y coordinate is set to a negative value out of the window
    -- Speed value is set to a random value from 100 to the maximum asteorid speed (updated by game)
    -- This function doesn't draw anything
    
    math.randomseed(os.time()) -- Random seed using the system clock, to obtain better random values.
    
    local spawnX =  math.random(0, love.graphics.getWidth())
    local spawnY = -100
    
    
    return newAsteroid(spawnX, spawnY, math.random(100, asteroidMaxSpeed))   
end


function unspawnAsteroid(i)
  -- This function deletes the asteroid with index [i] from asteroids collection. 
  -- The function doesn't return nothing
  table.remove(asteroidsCollection, i)
  -- print (#asteroidsCollection)
  -- asteroidsCollection[i] = nil
end

function spawnStar()
    -- This function sets (x,y) coordinates of a new star, creates it using newStar function, and returns it
    -- X coordinate is set to a random value from 0 to window width
    -- Y coordinate is set to a negative value out of the window
    -- This function doesn't draw anything
    
    math.randomseed(os.time() * 0.5) -- Random seed using the system clock, to obtain better random values.
    -- math.random(n1, n2) -- Returns a random number between n1 and n2
    
    local spawnX =  math.random(0, love.graphics.getWidth())
    local spawnY = -100
    return newStar(spawnX, spawnY)   
end

function unspawnStar(i)
  -- This function deletes the star with index [i] from stars collection. 
  -- The function doesn't return nothing
  table.remove(starsCollection, i)
end

function spawnBullets()
  -- This function creats TWO new bullets, fired from the WINGS of the ship.
  -- Right BUllet is fired from right wing
  -- Left Bullet is fired from left wing
  -- The function returns TWO bullets
  
  local spawnX = spaceShip.x + spaceShip.ox
  local spawnY = spaceShip.y
  local spawnX2 = spaceShip.x - spaceShip.ox
  local spawnY2 = spaceShip.y
  
  return newBullet(spawnX, spawnY), newBullet(spawnX2, spawnY2)
end

function unspawnBullet(i)
  -- This function deletes bullet from bullets collection
  table.remove(bulletsCollection, i)
end

function spawnShield()
    -- This function returns a new shield centered on the ship
    local spawnX = spaceShip.x 
    local spawnY = spaceShip.y 
    return newShield(spawnX, spawnY)
end

function unspawnShield()
  -- This function deletes space chip object
    shield = nil
end

function spawnExplosions()

  local spawnX = asteroid.x
  local spawnY = asteroid.y
  
  return newBullet(spawnX, spawnY)
end

function unspawnExplosion()
    table.remove(explosionCollection, i)
end
function  updateExplosions(dt)
  
  
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

function moveStars(dt)
  -- This function traverses the stars collection and increases y coordinate of overy star found
  -- Remember that you can find NIL spaces in the collection, so you must use a generic for with pairs()
  -- If after increasing y coordinate, an asteroid is out of the window, you have to unspawn it
  -- Remember that you have the speed value stored in a star object field
  
  -- We traverse stars collection with a generic for
  for index, star in pairs(starsCollection) do
    -- We update the coordinates of every star found
    star.y = star.y + star.speed * dt
    -- We check If asteroid is out of window
    if (star.y - star.oy) > h then 
      -- If so, we unspawn the asteroid by calling the function
      unspawnStar(index)
    end 
  end
end

function moveBullets(dt)
  -- This function moves all the spwaned bullets (directed from bottom to top). 
  -- Remember that you can find NIL spaces, so you must use generic for with pairs()
  -- Remember that bullets speed is stored in bullet object.
  -- You have to unspawn bullets when they are out of the window!
  
    for index, bullet in pairs(bulletsCollection) do
        bullet.y = bullet.y - bullet.speed * dt
        if (bullet.y + bullet.oy) < 0 then unspawnBullet(index) end
    end
    
end

function doDamageToAsteroid(i)
  -- This function damages asteroid with index i
  -- Remember that you have health points of the asteroids stored in the asteroid object
  -- The damage causes the change of the image file of the asteroid. You have all the image files sotred in the asteorid object, so you don't need to load them, just set the proper current image file to draw. Look at the object definition for further details!!
  asteroidsCollection[i].healthPoints = asteroidsCollection[i].healthPoints - 1
  if asteroidsCollection[i].healthPoints > 0 then
    asteroidsCollection[i].currentImageFile = asteroidsCollection[i].currentImageFile + 1
    asteroidsCollection[i].imageFile = love.graphics.newImage(asteroidsCollection[i].imageFiles[  asteroidsCollection[i].currentImageFile])
  end
end


function endGame()
  -- This function unspawns the ship and all bullets
    for index, bullet in pairs(bulletsCollection) do
        unspawnBullet(i)
    end
    unspawnSpaceShip()
end

function restartGame()
  -- This function does the following actions: 
  -- Respawn ship
  spaceShip = spawnSpaceShip()
  -- Respawn shield
  shield = spawnShield()
  -- Reset hud points
  hud.points = 0
  -- Reset asteroid maximum speed
  asteroidMaxSpeed = 100
  -- Set toogle draw shield to true
  toggleDrawShield = true
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

function drawStars()
    -- This function traverses the stars collection and draws every stars found.
    -- Remember that you can find NIL spaces in the collection, so you must use a generic for with pairs()
    -- Remember coordinates system and center of image
    for index, star in pairs(starsCollection) do
      love.graphics.draw(star.imageFile, star.x - star.ox, star.y - star.oy) 
    end
end

function drawBullets()
  -- This function draws all spawned bullets: 
  -- Remember that you cand find NIL values, so you MUST use generic for with pairs()
    for index, bullet in pairs(bulletsCollection) do
        love.graphics.draw(bullet.imageFile, bullet.x, bullet.y)
    end 
end

function drawShield()
  -- This function draws the shield around the ship
    love.graphics.draw(shield.imageFile, shield.activeFrame, shield.x - shield.ox, shield.y - shield.oy)
end

function drawExplosion()
    love.graphics.draw(explosion.imageFile, explosion.x, explosion.y )
end
function drawHUD()
    -- This function draws the HUD and prints game points. 
    love.graphics.setFont(hud.font)
    love.graphics.draw(hud.imageFile)
    love.graphics.print(hud.points, 20, 50)
end

function drawColliderRadius(gameObject) 
  -- This function draws collider radius of game object
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle("line", gameObject.x, gameObject.y, gameObject.colliderRadius)
  love.graphics.rectangle("fill", gameObject.x, gameObject.y, 4, 4)
  love.graphics.setColor(255, 255, 255)
end

function getDistance(gameObject1, gameObject2)
  -- This function returns the distance between two game objects, measured from its CENTER coordinates (x,y)
  return math.sqrt((gameObject1.x - gameObject2.x)^2 + (gameObject1.y - gameObject2.y)^2)
end

function isColliding(gameObject1, gameObject2) 
  -- This function returns true if gameObject1 and gameObject2 are colliding, false if they're not colliding
     if getDistance(gameObject1, gameObject2) < (gameObject1.colliderRadius + gameObject2.colliderRadius) then
      return true
    else 
      return false
    end
end

function checkBulletCollisions()
  -- This function checks collision of ALL bullets spawned in game. 
  -- You have to traverse the bullets collection, and for every bullet, you have to traverse the asteroids collection
  -- If a 
  local bulletCollision = false
  for i = 1, #bulletsCollection do
    for j = 1, #asteroidsCollection do
      if isColliding(bulletsCollection[i], asteroidsCollection[j]) then
        bulletCollision = true
        doDamageToAsteroid(j)
        if asteroidsCollection[j].healthPoints <= 0 then
          unspawnAsteroid(j)
          hud.points = hud.points + 100
          updateAsteroidSpeed = true
        end
        break 
      end
    end
    if bulletCollision then 
        unspawnBullet(i)
        bulletCollision = not(bulletCollision) 
        break 
      end
  end
end

function checkSpaceShipCollision()
    for i = 1, #asteroidsCollection do
      if isColliding(asteroidsCollection[i], spaceShip) then
          endGame()
          break
      end
    end
    if spaceShip then
      for i = 1, #starsCollection do
        if isColliding(starsCollection[i], spaceShip) then
          unspawnStar(i)
          shield = spawnShield()
          toggleDrawShield = true
        end
      end
    end
end

function love.load() 
  
    -- Load background image file
    backgroundImageFile = love.graphics.newImage("background.jpg")
    
    -- Sets w,h to window dimensions
    w, h = love.graphics.getDimensions()
    
    -- Spawn ship
    spaceShip = spawnSpaceShip()
   
   -- Spawn shield
    shield = spawnShield()
    
end



function love.update(dt)
  -- This function runs every frame
  
  -- We only have to update game objects if game is not paused and space ship is spawned
  -- So, first of all we check if game is not paused and space ship is spawned. 
  
  -- Remember that if the shield is spawned, you have to move it!!
  if(not(gamePaused) and spaceShip) then
    -- We update our time counters
    asteroidsTimeCounter = asteroidsTimeCounter + dt
    starsTimeCounter = starsTimeCounter + dt
    
    -- Key events control. We use arrow keys ("right", "left", "up", "down")
    -- We update x,y of the spaceship
    -- We check every key event in pooling mode (love.keyboard.isDown())
    
    if love.keyboard.isDown("right") then
        spaceShip.x = spaceShip.x + spaceShip.speed * dt
        if shield then shield.x = shield.x + spaceShip.speed * dt end
    end
    
    if love.keyboard.isDown("left") then
        spaceShip.x = spaceShip.x - spaceShip.speed * dt
        if shield then shield.x = shield.x - spaceShip.speed * dt end
    end
    
    if love.keyboard.isDown("up") then
        spaceShip.y = spaceShip.y - spaceShip.speed * dt
        if shield then shield.y = shield.y - spaceShip.speed * dt end
    end
    
    if love.keyboard.isDown("down") then
        spaceShip.y = spaceShip.y + spaceShip.speed * dt
        if shield then shield.y = shield.y + spaceShip.speed * dt end
    end
      
  
    checkBulletCollisions()
    
    if spaceShip and not shield then
      checkSpaceShipCollision()
    end
    
    -- We check if we have to spawn a new asteroid (asteroids time counter has reached the preset value)
    if asteroidsTimeCounter > asteroidsSpawnTime then
      -- If so, we spawn a new asteroid and we add it to asteroids collection
      asteroidsCollection[#asteroidsCollection + 1] = spawnAsteroid()
      -- We have to reset our asterois time counter
      asteroidsTimeCounter = 0
    end
    
    -- We check if we have to spawn a new star (star time counter has reached the preset value)
    if starsTimeCounter > starsSpawnTime then
      -- If so, we spawn a new asteroid and we add it to asteroids collection
      starsCollection[#starsCollection + 1] = spawnStar()
      -- We have to reset our asterois time counter
      starsTimeCounter = 0
    end
    

    
    -- We move asteroids by calling the function
      moveAsteroids(dt)
    
    -- We move stars by calling the function
      moveStars(dt)
    
    -- We move bullets by calling the function
      moveBullets(dt)
      
      updateExplosions(dt)
  end
  
  
  -- Update shield properties. You have to 
  if shield then
    shieldTimeCounter = shieldTimeCounter + dt
    if shieldTimeCounter > shieldSpawnedTime then
      unspawnShield()
      shieldTimeCounter = 0
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
    elseif key == "space" and spaceShip then
        bulletsCollection[#bulletsCollection + 1],  
        bulletsCollection[#bulletsCollection + 2]= spawnBullets()
    elseif key == "return" and not(spaceShip)  then
      restartGame()
    end
  end  
  
  -- We check if we reached 1000 points (and 2000, 3000, etc.)
    -- Be careful with the condition!!!
  if hud.points > 0 and hud.points % 1000 == 0 and updateAsteroidSpeed then
      -- If so, we increase asteorid speed in 5 px/s
        asteroidMaxSpeed = asteroidMaxSpeed + 10
        updateAsteroidSpeed = false
  end
 
 -- Control shield blinking
 blinkingShieldTimeCounter = blinkingShieldTimeCounter + dt
 if shieldTimeCounter > shieldFixedTime then
   if blinkingShieldTimeCounter > shieldAnimationTime then
      toggleDrawShield = not(toggleDrawShield)
      blinkingShieldTimeCounter = 0
   end
  end
 
end



function love.draw()
  -- Draw backgorund
  love.graphics.draw(backgroundImageFile)
  
  -- Draw asteroids
  drawAsteroids()
  
  -- Draw stars
  drawStars()
  
  drawExplosion()
  -- Draw space ship
  if spaceShip then
    love.graphics.draw(spaceShip.imageFile, spaceShip.x - spaceShip.ox, spaceShip.y - spaceShip.oy)
  end
  
  -- Draw shield
  if shield and toggleDrawShield then
    drawShield()
  end
  
  -- Draw bullets
  drawBullets()
  
  -- Draw HUD
  drawHUD()
  
  -- Draw collider radius of ALL objects in game (if "c" key pressed)
  if love.keyboard.isDown("c") then 
    drawColliderRadius(spaceShip)
    for i = 1, #asteroidsCollection do
      drawColliderRadius(asteroidsCollection[i])
    end
    for i = 1, #bulletsCollection do
      drawColliderRadius(bulletsCollection[i])
    end
    for i = 1, #starsCollection do
      drawColliderRadius(starsCollection[i])
    end
    
  end

end
