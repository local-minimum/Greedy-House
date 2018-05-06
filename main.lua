require("player")
require("daynight")
require("singleBackground")
require("mappingBackground")
require("shadows")

local bg;
key = {
  img = nil,
  xPos = 18,
  yPos = 6
}

grid = {
  size = 32,
  xStart = 8,
  yStart = 32 + 20,
  screen = {
    xSize = 24,
    ySize = 9
  }
}

map = {}
map[1] =  "       #                          "
map[2] =  "       #                   #######"
map[3] =  "       #          ###             "
map[4] =  "    ####           #              "
map[5] =  "    #  ################    #      "
map[6] =  "  ######         #    ############"
map[7] =  "       ######   ###   #    #      "
map[8] =  "            #       # # #         "
map[9] =  "#############       #####         "
map[10] = "                    # # #         "
map[11] = "                      #           "

function love.load(arg)
  shadows.load(drawPos, daynight)
  streets = getMappingBackground(drawPos, daynight)
  bg = getSingleBackground(drawPos, daynight)
  bg.load()
  key.img = love.graphics.newImage('assets/sprites/key.png')
  player.load()
  streets.load()
  streets.setCharacter("#")
  streets.setSpriteSize(grid.size)
  streets.setMap(map, grid.screen.xSize, grid.screen.ySize)
  daynight.setYMax(grid.screen.ySize)
  daynight.setSpeed(10)
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'right' or key == 'd' then
    player.update(streets, 1, 0)
  end
  if key == 'left' or key == 'a' then
    player.update(streets, -1, 0)
  end
  if key == 'up' or key == 'w' then
    player.update(streets, 0, 1)
  end
  if key == 'down' or key == 's' then
    player.update(streets, 0, -1)
  end
end

function love.update(dt)
  daynight.update(dt)
end

function love.draw()
  bg.draw(2, 2, 25, 10, -2, -2)
  streets.draw(2, 2, 25, 10, -2, -2)
  local keyPos = drawPos(key);
  love.graphics.draw(key.img, keyPos.x, keyPos.y)
  player.draw(streets, drawPos, daynight)
  shadows.draw(2, 2, 25, 10, -2, -2)
  debugStats()
end

function debugStats()
  local width, height, _ = love.window.getMode()
  love.graphics.printf(
    string.format(
      "Player {%i, %i} | Street %s | Screen {%i, %i}",
      player.position.xPos,
      player.position.yPos,
      streets.isStreet(player.position.xPos, player.position.yPos),
      width,
      height
    ),
    width / 2 - 300,
    height - 20,
    600,
    "center"
  )
end

function drawPos(item)
  local _, height, _ = love.window.getMode()

  return {
    x = item.xPos * grid.size + grid.xStart,
    y = height - (item.yPos * grid.size + grid.yStart)
  }
end
