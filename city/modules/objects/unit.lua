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

        u.tree = BTDatabase.Builder.new(u)
        u.timer = 0
        u.timerMax = 0.5

        u.health = Health.new(hp, u)
        
        u.id = unit.id
        unit.id=unit.id+1

        u.select = function()
            u.selected=true
            table.insert(UnitController.selectedUnits, u)
            u.selectID = #UnitController.selectedUnits
        end

        u.deselect = function()
            u.selected=false
            table.remove(UnitController.selectedUnits, u.selectID)
            u.selectID = -1
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
            end
        end
        
        u.cancelPath = function ()
            u.pathTarget=nil
            u.path={}
            u.setTree(nil)
        end

        u.setTree = function(tree)
            u.tree = tree
            u.timer = u.timerMax+1
        end

        u.update = function (dt)
            if u.tree ~=nil then
                u.timer = u.timer +dt
                if u.timer>u.timerMax then
                    u.tree.tree.process()
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