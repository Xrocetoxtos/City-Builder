local R = {}

    R.id= 0
    R.new = function(coordinate, data)
        local r = {}

        r.type = data
        r.coordinate = coordinate
        r.position = Map.getGridPosition(coordinate)

        r.draw = function ()
            if r.data == nil then 
                -- de sprite of, als die er niet is: een kruisje ofzo
            end


        end

        return r
    end

return R