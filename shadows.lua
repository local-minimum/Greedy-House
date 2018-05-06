local _data = {}
shadows = {
  load = function(posFunc, daynight)
    _data.daynight = daynight
    _data.posFunc = posFunc
    _data.halfDark = love.graphics.newImage("assets/sprites/overlayHalfNight.png")
    _data.halfLight = love.graphics.newImage("assets/sprites/overlayHalfDay.png")
    _data.duration = 2
  end,

  draw = function(x0, y0, x1, y1, xOffset, yOffset)
    local row, col, halfDark, halfLight
    for row = y0, y1 do
      col = _data.daynight.getDawnColumn(row)
      if col ~= nil then
        for halfLight = col + 1, col + _data.duration + 1 do
          if halfLight >= x0 and halfLight <= x1 then
            local pos = _data.posFunc({xPos = halfLight + xOffset, yPos = (y1 - row) + y0 + yOffset})
            love.graphics.draw(_data.halfLight, pos.x, pos.y)
          end
        end
      else
        col = _data.daynight.getDuskColumn(row)
        if col ~= nil then
          for halfDark = col + 1, col + _data.duration + 1 do
            if halfDark >= x0 and halfDark <= x1 then
              local pos = _data.posFunc({xPos = halfDark + xOffset, yPos = (y1 - row) + y0 + yOffset})
              love.graphics.draw(_data.halfDark, pos.x, pos.y)
            end
          end
        end
      end
    end
  end
}
