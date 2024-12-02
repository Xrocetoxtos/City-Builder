local R = {}

    R.id= 0
    R.new = function(coordinate, data)
        local r = {}

        r.data = data
        r.coordinate = coordinate
        r.position = Map.getGridPosition(coordinate)
        r.time = data.time
        r.currentTime = 0

        Map.pathfindingMap[r.coordinate.y][r.coordinate.x] = 1  --misschien niet alle types of pas als "ontdekt"

        r.id = R.id
        R.id = R.id + 1

        r.draw = function ()
            if r.data ~= nil then 
                -- de sprite of, als die er niet is: een kruisje ofzo
                if r.data.sprite == nil then
                    if r.empty ==  true then
                        Colours.setColour(Colours.RED)
                    end
                    love.graphics.line(r.position.x, r.position.y, r.position.x+10, r.position.y+10)
                    love.graphics.line(r.position.x+10, r.position.y, r.position.x, r.position.y+10)
                    Colours.setColour(Colours.WHITE)
                else
                    love.graphics.draw(r.data.sprite, r.position.x, r.position.y)
                end
            end
            
        end

        r.gather = function()
            r.currentTime = r.currentTime + DELTA
            print("gather de gather")
        end

        r.empty = function() 
            return r.currentTime >= r.time
        end

        return r
    end

return R