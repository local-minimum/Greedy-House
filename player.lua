local _position = {xPos=2, yPos=5}
local _images = {light={}, dark={}}

local function _isAllowedPos (streets, x, y)
  return streets.isVisibleLocal(x, y) and streets.hasStreetNear(x, y)
end

player = {
  images = _images,
  position = _position,

  update = function(streets, moveX, moveY)
      local nextX = moveX + _position.xPos
      local nextY = moveY + _position.yPos
      if _isAllowedPos(streets, nextX, nextY) then
        _position.xPos = nextX
        _position.yPos = nextY
      end
  end,

  load = function()
    _images.light.walk = {
      love.graphics.newImage('assets/sprites/player.png')
    }
    _images.dark.walk = {
      love.graphics.newImage('assets/sprites/player-dark.png')
    }
  end,

  draw = function(street, drawPos, daynight)
    local playerPos = drawPos(_position);
    if street.isStreet(_position.xPos, _position.yPos) ~= daynight.isDay(_position.xPos, _position.yPos) then
      love.graphics.draw(_images.dark.walk[1], playerPos.x, playerPos.y)
    else
      love.graphics.draw(_images.light.walk[1], playerPos.x, playerPos.y)
    end
  end
}
