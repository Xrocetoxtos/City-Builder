local B = {}
    B.id = 0
    function B.new(position,building)
        local b = {}
            b.x=position.x
            b.y=position.y
            b.building = building
     
            
            local x = math.ceil((b.x + 1) /Map.cellSizePixels)
            local y = math.ceil((b.y + 1) /Map.cellSizePixels)
            local coordinates =  Vector(x,y)
            Map.pathfindingMap[coordinates.y][coordinates.x] = 1
            Map.debugPathfindingGrid()


            b.load=function()
                
            end

            b.update=function(dt)

            end

            b.draw=function()
                love.graphics.rectangle("line",b.x,b.y,Map.cellSize, Map.cellSize)

            end

            b.id = B.id
            B.id = B.id + 1
        return b
    end

return B