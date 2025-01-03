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
        u.maxDistance= 500

        u.delete = false

        u.idleTree = BTDatabase.Idle.new({u})
        u.tree = u.idleTree
        
        u.timer = 0
        u.timerMax = 0.5

        u.health = Health.new(hp, u)

        u.currentDirection = Direction.NONE
        u.currentAnimation = Animations.villager.idle
        u.busy=false
        
        u.id = unit.id
        unit.id=unit.id+1

        u.select = function()
            u.selected=true
            table.insert(UnitSelector.selectedUnits, u)
            u.selectID = #UnitSelector.selectedUnits
            if #UnitSelector.selectedUnits == 1 then
                BuildingControllerDisplay.setElements()
            end
        end

        u.deselect = function()
            u.selected=false
            table.remove(UnitSelector.selectedUnits, u.selectID)
            u.selectID = -1
            if #UnitSelector.selectedUnits == 0 then
                BuildingControllerDisplay.clearElements()
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
            if pathLength ~=nil and pathLength > 0 then
                table.remove(u.path, 1)
            else
                print("geen path bepaald")
            end
        end

        u.setPathTowards = function(coordinate, rings)
            if rings == nil then rings = 1 end
            -- coordinate.x=coordinate.x-1
            -- coordinate.y=coordinate.y-1
            local destination = UnitOrders.findNodeAround(coordinate, u, rings)
            if destination ~= nil then
                u.setPath(destination)
            end
        end

        u.setTarget = function(building)
            if building == nil then
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
                -- u.tree = tree.new(u)
                u.tree = tree
                u.timer = u.timerMax+1
                    
            end
        end

        u.update = function ()
            if u.tree ~= nil and u.tree.name ~= "" then
                u.timer = u.timer + DELTA 
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

                u.move() 
            else
                if u.busy ==  false then
                    -- print("niet busy ----")
                    u.setWalkingAnimation(Direction.NONE)
                -- else 
                --     print("wel busy ----")

                end
            end
            u.currentAnimation:update(DELTA)
        end

        u.move = function()
            local nextPosition = Map.getGridPosition(u.path[1]) + Map.halfTile
            local distance = u.position:dist(nextPosition)
            if distance < 1 then
                u.position = nextPosition
                table.remove(u.path,1)
                return
            end
            local velocity = nextPosition-u.position
            velocity= velocity:normalized()
            velocity.x = velocity.x * u.moveSpeed * DELTA
            velocity.y = velocity.y * u.moveSpeed * DELTA

            local direction = Utils.vectorToDirection(velocity)
            if direction ~= u.currentDirection then
                u.setWalkingAnimation(direction)
                u.currentDirection = direction
            end

            u.position = u.position + velocity
        end

        u.setWalkingAnimation = function(direction)
            -- local newAnimation
            -- print(direction)
            if direction == Direction.NONE then u.setAnimation(Animations.villager.idle) end
            if direction == Direction.NORTH then u.setAnimation(Animations.villager.walkDU) end
            if direction == Direction.EAST then u.setAnimation(Animations.villager.walkLR) end
            if direction == Direction.SOUTH then u.setAnimation(Animations.villager.walkUD) end
            if direction == Direction.WEST then u.setAnimation(Animations.villager.walkRL) end

            -- if newAnimation ~= u.currentAnimation then
            --     u.currentAnimation = newAnimation
            -- end
        end

        u.setAnimation = function(animation)
            local newAnimation = animation
            if newAnimation ~= u.currentAnimation then
                print("new animation")
                u.currentAnimation = newAnimation
            end      
        end

        u.draw = function ()
            local healthBar= false
            local type = "line"
            if u.selected then
                type = "fill"
                healthBar=true
            end
            --love.graphics.circle(type, u.position.x, u.position.y, 5*Map.scale)
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
            u.currentAnimation:draw(Sprites.villager,u.position.x-8, u.position.y-8,0,Map.scale)
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