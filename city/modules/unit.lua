local unit = {}

    unit.new = function (coordinate)
        local u = {}
        u.coordinate = coordinate
        u.position = Map.getGridPosition(coordinate) + Map.halfTile
        u.selected = false
        u.delete = false

        u.toggleSelected = function()
            if u.selected then 
                u.selected=false
            else
                u.selected=true
            end            
        end
        
        u.setCoordinate = function ()
           u.coordinate = Map.getGridCoordinate(u.position) 
        end

        u.update = function (dt)
           -- print(u.position.x..":"..u.position.y)
        end

        u.draw = function ()
            local type = "line"
            if u.selected then
                type = "fill"
            end
            love.graphics.circle(type, u.position.x, u.position.y, 10)
        end

        return u
    end

return unit