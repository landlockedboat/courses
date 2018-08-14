--[[
Recursivitat

n! = n * (n - 1) * (n - 2) * (n - 3) * .... 1
0! = 1
--]]

-- Factorial function in iterative mode
function factorial(n) 
  --[[
  if n == 0 then 
    return 1
  end
  --]]
  local fact = 1
  
  for i = n, 1, -1 do
      fact = fact * i
  end
  return (fact)
end

--[[0! = 1
n! = n * (n-1)!
n = 1 --> n! = 1*0! = 1
n = 2 --> n! = 2*1! = 2
n = 3 --> n! = 3*2! = 6
--]]
-- Factorial functionin recursive mode


function factorialRecursive(n) 
  if (n == 0) then 
    return 1
  else
    return n * factorialRecursive(n-1)
  end
end


--[[
n = 5

for i = 1, 100000000 do
  fact = factorialRecursive(n)
end

--]]

--[[
print (n .. "!= " .. fact)
os.clock()
--]]

function fibonacci(n)
  if ((n == 0) or (n == 1)) then
    return 1
  else
    local fibo = fibonacci(n-1) + fibonacci(n-2)
    return fibo
  end
end

num = io.read()
for i = 1, num do
  print(fibonacci(i))
end

