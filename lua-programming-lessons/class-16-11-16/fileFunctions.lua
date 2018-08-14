function readFileLine1(fileName)
    io.input(fileName)
    fileLine = io.read()
    io.input(io.stdin)
    return fileLine
end

function writeFileLine1(fileName, fileLine)
  io.output(fileName)
  io.write(fileLine)
  io.output(io.stdout)
end

function readFileLine2(fileName)
    f = io.open(fileName, "r")
    if (f) then
      --fileLine = f.read(f)
      fileLine = f:read() -- better option, further details in next lessons
    end
    return fileLine
end

function writeFileLine2(fileName, fileLine)
    f = io.open(fileName, "a")
    if (f) then
      f.write(f, fileLine)
      --f:write(fileline) -- better option, further details in next lessons
      -- coses.txt -> "hola \n adeu \n"
      -- "caca" -> coses.txt (append mode)
      -- coses.txt -> "hola \n adeu \n caca"

    end
    --f.flush(f)
    f.close(f)
end

function printFileLines1(fileName)
    io.input(fileName)
    while(io.read()) do
      fileLine = io.read()
      print(fileLine)
    end
end

function printFileLines2(fileName)
    f = io.open(fileName, "r")
    if (f) then
      fileLine  = f.read(f)
      while(fileLine) do
        print(fileLine)
        fileLine = f.read(f)
      end


      --[[repeat

        fileLine  = f.read(f)
        if(fileLine) then
          print(fileLine)
        end
      until (not(fileLine))
      --]]

    end
end

function printFileLines3(fileName)
    f = io.open(fileName, "r")
    if (f) then
        --fileContent = f.read(f, "*a")
        fileContent = f:read("*a")
        --print(f:read("*a"))
    end
    print(fileContent)
end

function printFileLines4(fileName)
  for line in io.lines(fileName) do
    print(line)
  end
end

function fileToTable(fileName)
  local fileLinesTable = {}
  --local i = 0
  for line in io.lines(fileName) do
    -- Plenar una taula buida
    fileLinesTable[#fileLinesTable + 1] = line
    --fileLinesTable[i + 1] = line
    --i = i + 1
  end
  return fileLinesTable
end

inputFileName = "inputTextFile.txt"
outputFileName = "outputTextFile.txt"

--[[print()
--fileLine = readFileLine1(inputFileName)
fileLine = readFileLine2(inputFileName)
print(fileLine)
--]]
print()

--writeFileLine1(outputFileName, fileLine)
--writeFileLine2(outputFileName, fileLine)
--printFileLines1(inputFileName)
--printFileLines2(inputFileName)
--printFileLines3(inputFileName)
--printFileLines4(inputFileName)


fileLinesTable = {}
---[[
if (io.open(inputFileName)) then
  --printFileLines(inputFileName)
  fileLinesTable = fileToTable(inputFileName)
end
--]]

---[[
print("File lines sorted in original order (with line number)")
for k, v in ipairs(fileLinesTable) do
  print(k, v)
end
--]]

---[[
--[[print ("\nFile lines sorted alphabetically (Uppercase goes first!)")
for k, v in sortedPairs(fileLinesTable, "value") do
    print(k, v)
end
--]]
