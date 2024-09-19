local unit = {}
    unit.id = 0

    unit.new = function (coordinate, hp)
        local u = {}
        u.coordinate = coordinate
        u.position = Map.getGridPosition(coordinate) + Map.halfTile
        u.selected = false
        u.selectID = -1

        u.pathTarget = nil
        u.path = {}
        u.moveSpeed = 30
        u.maxDistance= 50

        u.delete = false

        u.idleTree = BTDatabase.Idle.new(u)
        u.tree = u.idleTree
        -- u.tree = BTDatabase.Builder.new(u)
        u.timer = 0
        u.timerMax = 0.5

        u.health = Health.new(hp, u)
        
        u.id = unit.id
        unit.id=unit.id+1

        u.select = function()
            u.selected=true
            table.insert(UnitSelector.selectedUnits, u)
            u.selectID = #UnitSelector.selectedUnits
        end

        u.deselect = function()
            u.selected=false
            table.remove(UnitSelector.selectedUnits, u.selectID)
            u.selectID = -1
        end
        
        u.setCoordinate = function ()
           u.coordinate = Map.getGridCoordinate(u.position) 
        end

        u.setPath = function(coordinate)
            print("setpath")
            local pathLength =0
            u.pathTarget = coordinate
            u.path = {}
            u.path, pathLength = Map.pathfinder:getPath(u.coordinate.x, u.coordinate.y, coordinate.x, coordinate.y) 
            if pathLength ~=nil and pathLength > 0 then
                table.remove(u.path, 1)
            else
                print("geen path bepaald")
            end
        end

        u.setPathTowards = function(coordinate)
            -- coordinate.x=coordinate.x-1
            -- coordinate.y=coordinate.y-1
            local destination = UnitOrders.findNodeAround(coordinate, u)
            if destination ~= nil then
                u.setPath(destination)
            end
        end

        u.setTarget = function(building)
            if building == nil then
                print("geen building")
                return
            end
            local coordinate = building.coordinate
            local node = UnitOrders.findNodeAround(coordinate, u)
            if node ~= nil then
                u.setPath(node)
                return
            end
            print("geen target")
        end

        u.targetReached = function ()
            if u.path == nil then 
                print("geen path") 
                return false 
            end
            if #u.path < 1 then return true end

            local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
            local distance = u.position:dist(nextPosition)
            return distance < 1
        end
        
        u.cancelPath = function ()
            u.pathTarget=nil
            u.path={}
            u.setTree(nil)
        end

        u.setTree = function(tree)
            print (u.tree.name .."  -->  "..tree.name)
            if u.tree.name ~= tree.name then
                u.tree = tree.new(u)
                u.timer = u.timerMax+1
                    
            end
        end

        u.update = function (dt)
            if u.tree ~= nil and u.tree.name ~= "" then
                u.timer = u.timer +dt
                if u.timer>u.timerMax then
                    local test = u.tree.tree.process()
                    u.timer = 0
                end
            end
            if u.path ~=nil and #u.path > 0 then
                --raar gedrag als ik coordinaat bepaal via Map.getGridPosition()
                local x = math.ceil(u.position.x /Map.cellSizePixels)
                local y = math.ceil(u.position.y /Map.cellSizePixels)
                u.coordinate =  Vector(x,y)

                u.move(dt) 
            end

            -- if u.selected then
            --     if love.keyboard.isDown("p") then
            --         u.health.damage(1)
            --     end
            --     if love.keyboard.isDown("o") then
            --         u.health.heal(1)
            --     end
            -- end
        end

        u.move = function(dt)
            print("moving")
            local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
            local distance = u.position:dist(nextPosition)
            if distance < 1 then
                u.position = nextPosition
                table.remove(u.path,1)
                return
            end
            local velocity = nextPosition-u.position
            velocity= velocity:normalized()
            velocity.x = velocity.x * u.moveSpeed * dt
            velocity.y = velocity.y * u.moveSpeed * dt

            u.position = u.position + velocity
        end

        u.draw = function ()
            local healthBar= false
            local type = "line"
            if u.selected then
                type = "fill"
                healthBar=true
            end
            love.graphics.circle(type, u.position.x, u.position.y, 5*Map.scale)
            if DEBUG and u.path ~= nil and #u.path > 0 then
                local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
                love.graphics.line(u.position.x, u.position.y, nextPosition.x, nextPosition.y)
            end
            if u.coordinate.x == MousePointer.mouseGridPosition.x and u.coordinate.y == MousePointer.mouseGridPosition.y then
                healthBar=true
            end
            if healthBar then
                u.drawHealthBar()
            end
        end

        u.drawHealthBar = function()
            love.graphics.setColor(0,0,0,1)
            love.graphics.rectangle("fill", u.position.x-11, u.position.y-16, 22, 4)
            love.graphics.setColor(1,0,0,1)
            love.graphics.rectangle("fill", u.position.x-10, u.position.y-15, 20*u.health.getHealthRatio(), 2)
            love.graphics.setColor(1,1,1,1)
        end

        return u
    end

return unit