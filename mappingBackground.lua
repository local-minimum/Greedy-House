function getMappingBackground(drawPos, daynight)
  local data = {}
  local streetsCharacter
  local spriteSize
  local map
  local mapView = {}

  local function _isStreet(c)
    if c == streetsCharacter then
      return "1"
    else
      return "0"
    end
  end

  local function isStreet(x, y)
    return _isStreet(map[mapView.yMin + mapView.rows - y - 1]:sub(x + mapView.xMin, x + mapView.xMin)) == "1"
  end

  local function _getStreetPatternHash(x, y)
    -- Returns nil if no street in context
    -- Returns 1001 for straight vertical
    -- Returns 0110 for straight horizontal
    -- 1101 is a t cross
    if map[y]:sub(x,x) ~= streetsCharacter then
      return nil
    else
      local h = _isStreet(map[y - 1]:sub(x,x))
      h = h .. _isStreet(map[y]:sub(x-1,x-1))
      h = h .. _isStreet(map[y]:sub(x+1,x+1))
      h = h .. _isStreet(map[y+1]:sub(x,x))
      -- love.graphics.print(h, x*32, y*32-16)
      return h
    end
  end

  local function _getStreet(h, x, y)
    local night = not daynight.isDay(x, y)
    if h == "1001" then
      return {img=night and data.straight or data.straightDay, rotation=0, ox=0, oy=0}
    elseif h == "0110" then
      return {img=night and data.straight or data.straightDay, rotation=math.pi/2, ox=spriteSize, oy=0}
    elseif h == "1010" then
      return {img=night and data.turn or data.turnDay, rotation=math.pi, ox=spriteSize, oy=spriteSize}
    elseif h == "1100" then
      return {img=night and data.turn or data.turnDay, rotation=math.pi/2, ox=spriteSize, oy=0}
    elseif h == "0101" then
      return {img=night and data.turn or data.turnDay, rotation=0, ox=0, oy=0}
    elseif h == "0011" then
      return {img=night and data.turn or data.turnDay, rotation=3*math.pi/2, ox=0, oy=spriteSize}
    elseif h == "1101" then
      return {img=night and data.crossT or data.crossTDay, rotation=0, ox=0, oy=0}
    elseif h == "1110" then
      return {img=night and data.crossT or data.crossTDay, rotation=math.pi/2, ox=spriteSize, oy=0}
    elseif h == "1011" then
      return {img=night and data.crossT or data.crossTDay, rotation=math.pi, ox=spriteSize, oy=spriteSize}
    elseif h == "0111" then
      return {img=night and data.crossT or data.crossTDay, rotation=3*math.pi/2, ox=0, oy=spriteSize}
    elseif h == "1111" then
      return {img=night and data.crossX or data.crossXDay, rotation=0, ox=0, oy=0}
    elseif h == "0001" then
      return {img=night and data.terminator or data.terminatorDay, rotation=0, ox=0, oy=0}
    elseif h == "0100" then
      return {img=night and data.terminator or data.terminatorDay, rotation=math.pi/2, ox=spriteSize, oy=0}
    elseif h == "0010" then
      return {img=night and data.terminator or data.terminatorDay, rotation=3*math.pi/2, ox=0, oy=spriteSize}
    elseif h == "1000" then
      return {img=night and data.terminator or data.terminatorDay, rotation=math.pi, ox=spriteSize, oy=spriteSize}
    end
    return nil
  end

  return {

    load = function()
      data.straight = love.graphics.newImage('assets/sprites/road-straight.png')
      data.straightDay = love.graphics.newImage('assets/sprites/road-straight.day.png')
      data.turn = love.graphics.newImage('assets/sprites/road-turn.png')
      data.turnDay = love.graphics.newImage('assets/sprites/road-turn.day.png')
      data.crossT = love.graphics.newImage('assets/sprites/road-tcross.png')
      data.crossTDay = love.graphics.newImage('assets/sprites/road-tcross.day.png')
      data.crossX = love.graphics.newImage('assets/sprites/road-xcross.png')
      data.crossXDay = love.graphics.newImage('assets/sprites/road-xcross.day.png')
      data.terminator = love.graphics.newImage('assets/sprites/road-end.png')
      data.terminatorDay = love.graphics.newImage('assets/sprites/road-end.day.png')
    end,

    setCharacter = function(c)
      streetsCharacter = c
    end,

    setSpriteSize = function(s)
      spriteSize = s
    end,

    setMap = function(m, cols, rows)
      map = m
      mapView.yMin = 2
      mapView.xMin = 2
      mapView.cols = cols
      mapView.rows = rows
    end,

    draw = function(x0, y0, x1, y1, xOffset, yOffset)
      local row, col
      for col = x0, x1 do
        for row = y0, y1 do
          local h = _getStreetPatternHash(col, row)
          local pos = drawPos({xPos = col + xOffset, yPos = (y1 - row) + y0 + yOffset})
          local street = _getStreet(h, col, row)
          if street ~= nil then
            love.graphics.draw(street.img, pos.x + street.ox, pos.y + street.oy, street.rotation, 1, 1, 0, 0)
          end
        end
      end
    end,

    isStreet = isStreet,

    isVisibleLocal = function(x, y)
      return x >= 0 and y >= 0 and y < mapView.rows and x < mapView.cols
    end,

    hasStreetNear = function(x, y)
      if isStreet(x, y) then
        return true
      elseif isStreet(x - 1, y - 1) then
        return true
      elseif isStreet(x - 1, y) then
        return true
      elseif isStreet(x - 1, y + 1) then
        return true
      elseif isStreet(x, y - 1) then
        return true
      elseif isStreet(x, y + 1) then
        return true
      elseif isStreet(x + 1, y - 1) then
        return true
      elseif isStreet(x + 1, y) then
        return true
      elseif isStreet(x + 1, y + 1) then
        return true
      end
      return false
    end
  }
end
