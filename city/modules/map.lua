local map = {}

    map.load =function ()
        map.gameMap = STI('maps/testmap.lua')

        map.scale = 4

        map.mapWidth = map.gameMap.width * map.gameMap.tilewidth * map.scale
        map.mapHeight = map.gameMap.height * map.gameMap.tileheight *map.scale
    end

    map.update = function (dt)
        
    end

    map.draw = function ()
        love.graphics.push()
        love.graphics.scale(map.scale)
        map.gameMap:drawLayer(map.gameMap.layers["water"])
        map.gameMap:drawLayer(map.gameMap.layers["sand"])
        map.gameMap:drawLayer(map.gameMap.layers["grass"])
        love.graphics.pop()
    end

return map