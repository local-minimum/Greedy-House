local _dayLength = 100
local _daySpeed = 1
local _now = 1
local _yMax = 0
local _getDay = function()
  return math.floor(_now / _dayLength) + 1
end

daynight = {
  setSpeed = function(speed)
    _daySpeed = speed
  end,

  setYMax = function(yMax)
    _yMax = yMax
  end,

  setNow = function(now)
    _now = now
  end,

  update = function(dt)
    _now = _now + dt * _daySpeed
  end,

  isDay = function(x, y)
    local v = math.max(x - (_yMax - y), 0)
    local dawn = (_getDay() % 2) == 0
    return (v >= _now % _dayLength) == dawn
  end,

  getDawnColumn = function(y)
    local dawn = (_getDay() % 2) == 0
    if not dawn then
      return nil
    end
    return math.floor(_now % _dayLength) + (_yMax - y)
  end,

  getDuskColumn = function(y)
    local dawn = (_getDay() % 2) == 0
    if dawn then
      return nil
    end
    return math.floor(_now % _dayLength) + (_yMax - y)
  end,

  getDay = _getDay
}
