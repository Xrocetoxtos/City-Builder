local D = {}

    local function dropObject(args)
        local position = args[1]
        local drop = args[2]

        ResourceController.addResource(position, drop)
    end

    function D.new (parent, drop, dropTime)
        local d = {}

            d.parent = parent
            d.drop = drop
            d.dropTime = dropTime or nil
            if d.dropTime ~= nil then
                d.progress = Progress.new(parent, dropTime, dropObject, {parent, drop} )
            end

            function d.dropObject()
                local position = UnitController.findNodeAround(parent.coordinate)    

                dropObject({position, d.drop})
            end

            function d.progress()
                --groeien naar dropobject
            end

        return d
    end

return D