local unit = {}
    unit.id = 0

    unit.new = function (coordinate)
        local u = {}
        u.coordinate = coordinate
        u.position = Map.getGridPosition(coordinate) + Map.halfTile
        u.selected = false

        u.pathTarget = nil
        u.path = {}
        -- u.pathLength = 0
        u.moveSpeed = 30

        u.delete = false
        u.test=false
        
        u.id = unit.id
        unit.id=unit.id+1

        u.toggleSelected = function()
            if u.selected then 
                u.selected=false
                table.remove(UnitController.selectedUnits, u.selectID)
            else
                u.selected=true
                table.insert(UnitController.selectedUnits, u)
                u.selectID = #UnitController.selectedUnits
            end            
        end
        
        u.setCoordinate = function ()
           u.coordinate = Map.getGridCoordinate(u.position) 
        end

        u.setPath = function(coordinate)
            local pathLength =0
            u.pathTarget = coordinate
            u.path = {}
            u.path, pathLength = Map.pathfinder:getPath(u.coordinate.x, u.coordinate.y, coordinate.x, coordinate.y) 
            if pathLength > 0 then
                table.remove(u.path, 1)
            end
        end
        
        u.cancelPath = function ()
            u.pathTarget=nil
            u.path={}
        end

        u.update = function (dt)
            if #u.path > 0 then
                --raar gedrag als ik coordinaat bepaal via Map.getGridPosition()
                local x = math.ceil(u.position.x /Map.cellSizePixels)
                local y = math.ceil(u.position.y /Map.cellSizePixels)
                u.coordinate =  Vector(x,y)

                u.move(dt) 
            end
        end

        u.move = function(dt)
            local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
            local distance = u.position:dist(nextPosition)
            if distance < 3 then
                table.remove(u.path,1)
                print("new: "..nextPosition.x..":"..nextPosition.y)
                return
            end
            local velocity = nextPosition-u.position
            velocity= velocity:normalized()
            velocity.x = velocity.x * u.moveSpeed * dt
            velocity.y = velocity.y * u.moveSpeed * dt

            u.position = u.position + velocity
        end

        u.draw = function ()
            local type = "line"
            if u.selected then
                type = "fill"
            end
            love.graphics.circle(type, u.position.x, u.position.y, 10)
            if u.test then
                love.graphics.setColor(1,0,0,1)
                love.graphics.circle("fill", u.position.x, u.position.y, 5)
                love.graphics.setColor(1,1,1,1)

           end
            if #u.path > 0 then
                local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
                love.graphics.line(u.position.x, u.position.y, nextPosition.x, nextPosition.y)
            end
        end

        return u
    end

return unit