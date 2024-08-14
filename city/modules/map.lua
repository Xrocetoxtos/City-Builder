local map = {}

    map.load =function ()
        map.gameMap = STI('maps/testmap.lua')

        map.scale = 4

        map.mapWidth = map.gameMap.width * map.gameMap.tilewidth * map.scale
        map.mapHeight = map.gameMap.height * map.gameMap.tileheight *map.scale
        map.setupPathfinding()
    end

    function map.setupPathfinding()
        map.walkable = 0
        map.pathfindingMap = {}
        for i = 1, map.gameMap.layers[2].width, 1 do
            map.pathfindingMap[i] = {}
        end
        local mapdata = require('maps.testmap')

        local x = 1
        local y = 1
        for i = 1, mapdata.layers[2].height*mapdata.layers[2].width do
            if mapdata.layers[2].data[i]~=0 then
                map.pathfindingMap[y][x] = 0
            else
                map.pathfindingMap[y][x] = 1
            end
            x=x+1
            if x> mapdata.width then
                x=1
                y=y+1
            end
        end

        for x = 1, 30, 1 do
            local line = ""
            for y=1, 30, 1 do
                line = line .. map.pathfindingMap[x][y].." "
            end
            print(line)
        end

        map.pathfinder = Jumper(map.pathfindingMap,map.walkable) -- Inits a pathfinder

        -- testpath 2,2 --> 5-2
        -- local startx, starty = 2,2 -- The start location 
        -- local endx, endy = 5,2 -- The goal location 
        -- local path, pathLen = map.pathfinder:getPath(startx, starty, endx, endy) -- Gets the path

        -- if path then -- if a path was found
        --     print(('Path from [%d,%d] to [%d,%d] found! Length: %.2f')
        --         :format(startx, starty,endx,endy, pathLen))
        --     for x,y,step in path:iter() do -- iterates through the path, printing x, y coordinates
        --         print(('Step: %d - x: %d - y: %d'):format(step,x,y))
        --     end
        -- end
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