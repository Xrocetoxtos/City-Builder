local B = {}
    B.finishBuilding = function (building)
        print("finish " .. building.buildingData.name)
        building.finish()
    end

    B.id = 0
    function B.new(position,building)
        local b = {}
            b.x=position.x
            b.y=position.y
            b.buildingData = building

            b.buildingProgress = Progress.new(b, 100, B.finishBuilding, b) 
            b.finished = false

            ResourceController.payResources(building.resource)
            
            local x = math.ceil((b.x + 1) / Map.cellSizePixels)
            local y = math.ceil((b.y + 1) / Map.cellSizePixels)
            b.coordinate =  Vector(x,y)
            Map.pathfindingMap[b.coordinate.y][b.coordinate.x] = 1
            UnitController.reconsiderPaths()

            b.load=function()
                
            end

            b.finish = function()
                b.finished = true
                ResourceController.populationMax = ResourceController.populationMax + b.buildingData.population
            end

            b.update=function(dt)
                -- b.build(1)
                if b.finished == false then return end
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
                love.graphics.rectangle("line",b.x,b.y,Map.cellSize, Map.cellSize)

            end

            b.id = B.id
            B.id = B.id + 1
        return b
    end

return B