local R = {}

    R.id= 0
    R.new = function(coordinate, data)
        local r = {}

        r.data = data
        local rnd = math.random(1, #data.sprites)
        r.sprite = data.sprites[rnd]

        r.coordinate = coordinate
        r.position = Map.getGridPosition(coordinate)
        r.time = data.time
        r.currentTime = 0
        r.amount = data.amount

        r.objectDropper = nil
        if data.drop ~= nil then
            r.objectDropper = objectDropper.new(r, data.drop.dropObject, data.drop.dropTime)
            r.objectDropper.setProgress()
        end

        if data.walkable ~= true then
            Map.pathfindingMap[r.coordinate.y][r.coordinate.x] = 1 
        end

        r.id = R.id
        R.id = R.id + 1

        r.update = function()
            if r.objectDropper ~= nil then
                --r.objectDropper.update()
            end
        end

        r.draw = function ()
            if r.data ~= nil then 
                if r.sprite == nil then
                    love.graphics.line(r.position.x, r.position.y, r.position.x+10, r.position.y+10)
                    love.graphics.line(r.position.x+10, r.position.y, r.position.x, r.position.y+10)
                else
                    love.graphics.draw( r.data.image, r.sprite, r.position.x, r.position.y)

                end
            end
            
        end

        r.gather = function()
            r.currentTime = r.currentTime + 0.5
        end
        
        r.gatherComplete = function() 
            return r.currentTime >= r.data.time
        end

        r.reduce = function (amount)
            r.amount = r.amount - amount
        end

        r.empty = function ()
            return r.amount <= 0
        end

        return r
    end

return R