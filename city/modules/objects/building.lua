local B = {}
    B.id = 0
    function B.new(position,building)
        local b = {}
            b.x=position.x
            b.y=position.y
            b.buildingdata = building

            b.buildingProgress = Progress.new(b, 100, b.finishBuilding)         -- TODO signal

            ResourceController.payResources(building.resource)
            
            local x = math.ceil((b.x + 1) / Map.cellSizePixels)
            local y = math.ceil((b.y + 1) / Map.cellSizePixels)
            b.coordinate =  Vector(x,y)
            Map.pathfindingMap[b.coordinate.y][b.coordinate.x] = 1
            UnitController.reconsiderPaths()

            b.load=function()
                
            end

            b.update=function(dt)
                if b.buildingProgress.current< b.buildingProgress.max then
                    b.buildingProgress.progress(1)

                end
            end

            b.finishBuilding = function ()
                print("finish")
            end

            b.draw=function()
                love.graphics.rectangle("line",b.x,b.y,Map.cellSize, Map.cellSize)

            end

            b.id = B.id
            B.id = B.id + 1
        return b
    end

return B