local B = {}

    function B.new(position,building)
        local b = {}
            b.x=position.x
            b.y=position.y
            b.building = building
            
            local coordinates = Map.getGridCoordinate(position+Vector(1,1)) -- +1 zodat ie niet op de hoek tussen de cellen staat, want dan is het coordinaat verkeerd
            Map.pathfindingMap[coordinates.y][coordinates.x] = 1
            Map.debugPathfindingGrid()


            b.load=function()
                
            end

            b.update=function(dt)

            end

            b.draw=function()
                love.graphics.rectangle("fill",b.x,b.y,Map.cellSize, Map.cellSize)

            end
        return b
    end

return B