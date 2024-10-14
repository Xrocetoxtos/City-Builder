local B = {}
    B.finishBuilding = function (building)
        building.finish()
    end

    B.id = 0
    function B.new(position,building)
        local b = {}
            b.x=position.x
            b.y=position.y
            b.data = building
            b.runningActions = {}

            b.buildingProgress = Progress.new(b, 100, B.finishBuilding, b) 
            b.finished = false

            ResourceController.payResources(building.resource)
            
            local x = math.ceil((b.x + 1) / Map.cellSizePixels)
            local y = math.ceil((b.y + 1) / Map.cellSizePixels)
            b.coordinate =  Vector(x,y)
            Map.pathfindingMap[b.coordinate.y][b.coordinate.x] = 1
            UnitOrders.reconsiderPaths()

            b.finish = function()
                b.finished = true
                ResourceController.populationMax = ResourceController.populationMax + b.data.population
            end

            b.addRunningAction = function(action)
                local ra = RunningAction.new(b,action)
                table.insert(b.runningActions, ra)
            end

            b.removeRunningAction = function(action)
                for index, value in ipairs(b.runningActions) do
                    if action.name == value.action.name then
                        table.remove(b.runningActions, index)
                        return
                    end
                end
            end

            b.activateRunningActions = function()           -- de eerste van een beaalde actie is actief.
                local done = {}
                for index, ra in ipairs(b.runningActions) do
                    done = b.setActive(done, ra)
                end
            end

            b.setActive = function(done, ra)
                print(ra.action.name)
                for i = 1, #done do
                    if done[i].name == ra.action.name then 
                        print ("afgekeurd") 
                        return done 
                    end
                end
                print("goedgekeurd")
                table.insert(done, ra.action)
                ra.setActive()
                return done 
            end

            b.update=function(dt)
                -- b.build(1)
                if b.finished == false then return end
                for index, ra in ipairs(b.runningActions) do
                    ra.update(dt)
                end
            end

            b.build = function (amount)
                if b.buildingProgress.current< b.buildingProgress.max and b.finished == false then
                    b.buildingProgress.progress(amount)
                end
            end

            b.showInfo = function()
                print(b.buildingProgress.current)
            end

            b.draw=function()
                local type = "line" 
                if b.finished == true then
                    type = "fill"
                end
                love.graphics.rectangle(type, b.x, b.y, Map.cellSize, Map.cellSize)
            end

            b.id = B.id
            B.id = B.id + 1
        return b
    end

return B