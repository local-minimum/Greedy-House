function getBackground(posFunc, daynight)
    local _images = {}

    return {
      _images = _images,

      load = function()
          _images.voidNight = love.graphics.newImage('assets/sprites/emptyNight.png')
          _images.voidDay = love.graphics.newImage('assets/sprites/emptyDay.png')
      end,

      draw = function(x0, y0, x1, y1, xOffset, yOffset)
        local row, col
        for col = x0, x1 do
          for row = y0, y1 do
            local pos = posFunc({xPos = col + xOffset, yPos = (y1 - row) + y0 + yOffset})
            love.graphics.draw(daynight.isDay(col, row) and _images.voidDay or _images.voidNight, pos.x, pos.y)
          end
        end
      end
    }
end
