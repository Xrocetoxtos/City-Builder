local R = {}

    R.id= 0
    R.new = function(coordinate, data)
        local r = {}

        r.data = data
        r.coordinate = coordinate
        r.position = Map.getGridPosition(coordinate)

        Map.pathfindingMap[r.coordinate.y][r.coordinate.x] = 1  --misschien niet alle types of pas als "ontdekt"


        r.id = R.id
        R.id = R.id + 1

        r.draw = function ()
            if r.data ~= nil then 
                -- de sprite of, als die er niet is: een kruisje ofzo
                if r.data.sprite == nil then
                    love.graphics.line(r.position.x, r.position.y, r.position.x+10, r.position.y+10)
                    love.graphics.line(r.position.x+10, r.position.y, r.position.x, r.position.y+10)
                else
                    love.graphics.draw(r.data.sprite, r.position.x, r.position.y)
                end
            end
        end

        return r
    end

return R