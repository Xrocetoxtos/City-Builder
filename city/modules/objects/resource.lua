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
            print(r.position)
            if r.objectDropper ~= nil then
                r.objectDropper.update()
            end
            -- print (r.position)
            -- print("---")
        end

        r.draw = function ()
            -- love.graphics.print(r.position, -50,-50)    -- Dit is omdat anders de locatie steeds verder naar beneden schuift...(y-positie stijgt met 100)
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
            print("resource gather")

            r.currentTime = r.currentTime + 0.5
        end
        
        r.gatherComplete = function() 
            print("resource gather complete")

            return r.currentTime >= r.data.time
        end

        r.reduce = function (amount)
            print("resource reduce " .. amount)

            r.amount = r.amount - amount
        end

        r.empty = function ()
            print("reduce empty" .. r.amount)

            return r.amount <= 0
        end

        return r
    end

return R