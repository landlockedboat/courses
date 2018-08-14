-- Functions and Objects in Lua

-- To represent a 2D vector, we can create a table with two fields, x and y:
vec2D = { x = 0 , y = 0 }


-- Now we can access the fields of the table in two ways:
vec2D.x = 3
vec2D.y = 4
-- vec2D["x"] = 3
-- vec2D["y"] = 4 -- also valid, but ugly in this case.






-- This function returns the modulus of a given vector
function getModulus(vec)
  return math.sqrt(vec.x^2 + vec.y^2)
end

-- We can store a function inside a variable (the hole function, NOT the result of the function)
-- Actually, function is a valida data type (like number, string, etc.)

modul = getModulus

--modul = getModulus() -- This line stores the RESULT of the function getModulus, not the function

-- We can call a function stored in a variable in the same way we call the function directly
print ("vec2D modulus: ", modul(vec2D))

-- We can store a function as a field of a table, like other data types

vec2D.getModulus = getModulus

-- Field with index "getModulus" stores getModulus() function
-- vec2D["getModulus"] = getModulus -- Remember, it does exactly the same!

-- Function getModulus (stored in a field of vec2D) returns the modulus of a given vector vec. Now, if we want to calculate the modulus of vec2D, we have to pass it as an argument to the function.
-- We can call a function stored in a table field in the same way we access a field of a table
print("vec2D modulus: ", vec2D.getModulus(vec2D))

-- As function getModulus takes an external parameter (vec), so it can work for other valid variables
-- (not only for vec2D).
anotherVec2D = { x = 4, y = 5}
print("anotherVec2D modulus: ", vec2D.getModulus(anotherVec2D))

-- Note that anotherVec2D doesn't have a getModulus function stored in a field of the table, so this code will not work:
-- anotherVec2D.getModulus(anotherVec2D)

-- Lua offers a sintatic sugar to avoid argument passing of the same table were the function is stored.
-- We can use the : (colon) operator, like this:

print("vec2D modulus: ", vec2D:getModulus()) -- This code adds Vec2D as hidden argument
print("vec2D modulus: ", vec2D.getModulus(vec2D)) -- This code does exactly the same

-- Now vec argument inside getModulus function stores vec2D



-- We can also define functions inside a table just setting the name of the function as the field name

  function vec2D.getAngle (vec)
    return math.atan(vec.y / vec.x) * 180 / math.pi
  end

-- This code does the same:
vec2D.getAngle =
  function (vec)
    return math.atan(vec.y / vec.x) * 180 / math.pi
  end
-- Note that function definition is anonymous, the hole function is stored in a table field.


-- We can also use the : (colon) operator to define a function inside a table field, adding a hidden extra argument to the function call, as we saw before.
-- This code does the same:

  function vec2D:getAngle()
    -- vec2D argument is hidden, we can use the "self" identifier
    return math.atan(self.y / self.x) * 180 / math.pi
  end




print("vec2D angle: ", vec2D:getAngle())

-- What if we create a new variable as a copy of vec2D ?
-- The new variable vec2Dcopy has the same fields as vec2D, so it has also the getModulus and getAngle function,
-- and we can use it the same way:
vec2Dcopy = vec2D
print("vec2Dcopy modulus: ", vec2Dcopy:getModulus())
print("vec2Dcopy angle: ", vec2Dcopy:getAngle())


-- We can define a table directly filling ts fields with values and functions.
newVec2D = {
            x = 3,
            y = 4,
            getModulus =
              function (self)
                return math.sqrt(self.x^2 + self.y^2)
              end,

            getAngle =
              function (self)
                return math.atan(self.y / self.x) * 180 / math.pi
              end
            }
-- Note the use os "self" in the function definitions inside the fields.
-- We can not use the : (colon) operator here, because we have to put the index of the field and the function as a value

print("newVec2D modulus: ", newVec2D:getModulus())
print("newVec2D angle: ", newVec2D:getAngle())

-- The vec2D tables looks liken an "object" (it has properties and methods), but it is a particular "instance", because it has particular values.

-- How we can create a "class" and "objects" as instances of the class ?
-- "Class" concept doesn't exist in Lua.

-- The are some methods to emulate the same behaviour
-- For instance, we can define a function to create "objects" with defined properties and functions, like this:

function createVec2D (x, y)

  local newVec2D = {}
  --local newVec2D = { x = x or 0, y = y or 0 }

  newVec2D.x = x or 0
  newVec2D.y = y or 0

  newVec2D.getModulus =
            function (vec)
              return math.sqrt(vec.x^2 + vec.y^2)
            end
  newVec2D.getAngle =
            function (vec)
              return math.atan(vec.y / vec.x) * 180 / math.pi
            end
  return newVec2D
end

vector2DInstance1 = createVec2D() -- Creates a vector and sets x = 0, y = 0 (default)
vector2DInstance2 = createVec2D(3, 4)  -- Creates a vectors and sets x = 3, y = 4

-- We can define a "class", with a "new" function to create instances, like this:

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
                  newVec2D.isCool = true;
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

function createVec2Dvariadic (...)
  x, y = ...
  local newVec2D = {x, y, getModulus, getAngle}
  newVec2D.x = x or 0
  newVec2D.y = y or 0
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

function createVec2DGeneric (...)
  local val1, val2, mode = ...
  mode = mode or "rect"
  if mode == "rect" then
    local newVec2D = {x, y, getModulus, getAngle, vecMode}
    newVec2D.x = val1 or 0
    newVec2D.y = val2 or 0
    newVec2D.getModulus =
            function (self)
              return math.sqrt(self.x^2 + self.y^2)
            end
    newVec2D.getAngle =
            function (self)
              return math.atan(self.y / self.x) * 180 / math.pi
            end
    newVec2D.vecMode = "rectangular"
    return newVec2D
  elseif mode == "pol" then
    local newVec2D = {r, alpha, getX, getY, vecMode}
    newVec2D.r = val1 or 0
    newVec2D.alpha = val2 or 0
    newVec2D.getX =
            function (self)
              return self.r * math.cos(self.alpha * math.pi / 180)
            end
    newVec2D.getY=
            function (self)
              return self.r * math.sin(self.alpha * math.pi / 180)
            end
    newVec2D.vecMode = "polar"
    return newVec2D
  end

end
