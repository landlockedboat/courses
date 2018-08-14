function getReverseDiskType(diskType)
  if diskType == "light" then
    return "dark"
  end
  if diskType == "dark" then
    return "light"
  end
end

function initCaptureState(diskType, startRow, startColumn)
  local captureState = {}
  captureState.diskType = diskType
  captureState.beginning = false
  captureState.foundWhite = false
  captureState.lastDiskType = "nil"
  captureState.foundMyDisk = false
  captureState.startRow = startRow;
  captureState.startColumn = startColumn;
  captureState.startBox = {}
  captureState.endBox = {}
  return captureState
end

function genericCaptureIteration (cs)
  -- cs -> CaptureState
  v = gameBoardBoxes [cs.i][cs.j]
  if v.diskType == cs.diskType then

    if cs.lastDiskType == cs.diskType then
      if cs.beginning then
        cs.foundWhite = false
        cs.foundMyDisk = false
        cs.beginning = false
      end
    elseif cs.lastDiskType == "nil" then
      if cs.i == cs.startRow and cs.j == cs.startColumn then
        cs.foundMyDisk = true
      end
      cs.beginning = true
      cs.startBox.x = cs.j
      cs.startBox.y = cs.i
      cs.lastDiskType = cs.diskType
    elseif cs.lastDiskType == getReverseDiskType(cs.diskType) then
      if cs.beginning and cs.foundWhite and
      (cs.foundMyDisk or (cs.i == cs.startRow and cs.j == cs.startColumn))
      then
        cs.endBox.x = cs.j
        cs.endBox.y = cs.i
        return true
      else
        cs.foundWhite = false
        cs.beginning = false
        cs.foundMyDisk = false
        cs.lastDiskType = cs.diskType
      end
    end
  elseif v.diskType == "nil" then
    cs.lastDiskType = "nil"
    cs.foundWhite = false
    cs.beginning = false
    cs.foundMyDisk = false
  elseif v.diskType == getReverseDiskType(cs.diskType) then
    cs.lastDiskType = v.diskType
    if(cs.beginning) then
      cs.foundWhite = true
    else
      cs.foundWhite = false
      cs.beginning = false
      cs.foundMyDisk = false
    end
  end
  return false
end

function checkHorizontalCapture(diskType, startRow, startColumn)
  local captureState = initCaptureState(diskType, startRow, startColumn)
  for i = 1,8 do
    captureState.i = startRow
    captureState.j = i
    found = genericCaptureIteration(captureState)
    if(found) then
      return true, captureState.startBox, captureState.endBox
    end
  end
  return false
end

function checkVerticalCapture(diskType, startRow, startColumn)
  captureState = initCaptureState(diskType, startRow, startColumn)

  for i = 1,8 do
    captureState.i = i
    captureState.j = startColumn
    found = genericCaptureIteration(captureState)
    if(found) then
      return true, captureState.startBox, captureState.endBox
    end
  end
  return false
end

function checkTopDownDiagonalCapture(diskType, startRow, startColumn)
  captureState = initCaptureState(diskType, startRow, startColumn)

  for i = 1,8 do
    captureState.i = i
    captureState.j = i
    found = genericCaptureIteration(captureState)
    if(found) then
      return true, captureState.startBox, captureState.endBox
    end
  end
  return false
end

function checkDownTopDiagonalCapture(diskType, startRow, startColumn)
  captureState = initCaptureState(diskType, startRow, startColumn)

  for i = 1,8 do
    captureState.i = 8 - (i - 1)
    captureState.j = i
    found = genericCaptureIteration(captureState)
    if(found) then
      return true, captureState.startBox, captureState.endBox
    end
  end
  return false
end

function checkCaptures (diskType, startRow, startColumn)
  isTopDownDiagonalValid, startBox, endBox = checkTopDownDiagonalCapture(diskType, startRow, startColumn)

  isDownTopDiagonalValid, startBox, endBox = checkDownTopDiagonalCapture(diskType, startRow, startColumn)

  isVerticalValid, startBox, endBox = checkVerticalCapture(diskType, startRow, startColumn)

  isHorizontalValid, startBox, endBox = checkHorizontalCapture(diskType, startRow, startColumn)

  return isVerticalValid or isHorizontalValid or isDiagonalValid or isTopDownDiagonalValid or isDownTopDiagonalValid
end

function makeVerticalCapture (diskType, startBox, endBox)
  for i=startBox.y, endBox.y do
    gameBoardBoxes[i][startBox.x].diskType = diskType
  end
end

function makeHorizontalCapture (diskType, startBox, endBox)
  for i=startBox.x, endBox.x do
    gameBoardBoxes[startBox.y][i].diskType = diskType
  end
end

function makeTopDownDiagonalCapture (diskType, startBox, endBox)
  for i=startBox.x, endBox.x do
    gameBoardBoxes[i][i].diskType = diskType
  end
end

function makeDownTopDiagonalCapture (diskType, startBox, endBox)
  for i=startBox.x, endBox.x do
    gameBoardBoxes[8 - (i - 1)][i].diskType = diskType
  end
end

function makeCaptures(diskType, startRow, startColumn)

  -- TOP DOWN DIAGONAL

  isTopDownDiagonalValid, startBox, endBox = checkTopDownDiagonalCapture(diskType, startRow, startColumn)

  if(isTopDownDiagonalValid)then
    makeTopDownDiagonalCapture(diskType, startBox, endBox)
  end

  -- DOWN TOP DIAGONAL

  isDownTopDiagonalValid, startBox, endBox = checkDownTopDiagonalCapture(diskType, startRow, startColumn)

  if(isDownTopDiagonalValid)then
    makeDownTopDiagonalCapture(diskType, startBox, endBox)
  end


  -- VERTICAL
  isVerticalValid, startBox, endBox = checkVerticalCapture(diskType, startRow, startColumn)

  if(isVerticalValid)then
    makeVerticalCapture(diskType, startBox, endBox)
  end

  -- HORIZONTAL
  isHorizontalValid, startBox, endBox = checkHorizontalCapture(diskType, startRow, startColumn)

  if(isHorizontalValid)then
    makeHorizontalCapture(diskType, startBox, endBox)
  end
end
