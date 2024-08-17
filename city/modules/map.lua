local map = {}

    map.load =function ()
        map.gameMap = STI('maps/testmap.lua')

        map.scale = 2
        map.cellSize = map.gameMap.tilewidth
        map.cellSizePixels = map.cellSize * map.scale
        map.halfTile = Vector(map.cellSize * 0.5 * map.scale, map.cellSize * 0.5 * map.scale)

        map.mapWidth = map.gameMap.width * map.cellSize * map.scale
        map.mapHeight = map.gameMap.height * map.cellSize *map.scale
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

        map.debugPathfindingGrid()

        map.pathfinder = Jumper(map.pathfindingMap,map.walkable)
        
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

    function map.debugPathfindingGrid()
        if DEBUG then
            for x = 1, 30, 1 do
                local line = ""
                for y=1, 30, 1 do
                    line = line .. map.pathfindingMap[x][y].." "
                end
                print(line)
            end
        end
    end

    function map.getGridCoordinate(vector)
        if vector == nil then return nil end

        vector.x = vector.x + Pointer.position.x - HALF_WIDTH
        vector.y = vector.y + Pointer.position.y - HALF_HEIGHT

        local x = math.ceil(vector.x /map.cellSizePixels)
        local y = math.ceil(vector.y /map.cellSizePixels)
        return Vector(x,y)
    end

    function map.getGridPosition(coordinates)
        if coordinates == nil then return nil end

        return Vector((coordinates.x-1)*map.cellSizePixels, (coordinates.y-1)*map.cellSizePixels)

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