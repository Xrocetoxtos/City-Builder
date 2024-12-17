local U = {}

    Direction = {
        NORTH = "NORTH",
        EAST = "EAST",
        SOUTH = "SOUTH",
        WEST = "WEST",
        NONE = ""
    }

    function U.drawRect(type, pos, size)
        love.graphics.rectangle(type, pos.x, pos.y, size.x, size.y)
    end

    function U.vectorToDirection(vector)
        if vector.x == 0 and vector.y == 0 then return Direction.NONE end

        local x = math.abs(vector.x)
        local y = math.abs(vector.y)

        if vector.x > 0 then
            if x > y then return Direction.EAST end
            if vector.y > 0 then return Direction.SOUTH end
            return Direction.NORTH
        else
            if x > y then return Direction.WEST end
            if vector.y > 0 then return Direction.SOUTH end
            return Direction.NORTH  
        end
    end
return U