local D = {}

    function D.dropObject(args)
        local position = args[1]
        local drop = args[2]
        local d = args[3]

        if d.progress ~= nil then
            print("..........")
            position = ResourceController.findDropLocation(position)
        end

        print("   ----     ")
        print(position)
        if position ~= nil then
            ResourceController.addResource(position, drop)
        end
        --d.dropTime = nil
        if d.progress ~=nil then
            d.progress.reset()
        end
    end

    function D.new (parent, drop, dropTime)
        local d = {}

            d.parent = parent
            d.drop = drop
            d.dropTime = dropTime or nil

            function d.setProgress()
                if d.dropTime ~= nil then
                    local position = UnitController.findNodeAround(parent.coordinate)    

                    d.progress = Progress.new(parent, dropTime, D.dropObject, {position, drop, d} )
                end
            end

            function d.dropObject()
                --local position = UnitController.findNodeAround(parent.coordinate)    
                local position = ResourceController.findDropLocation(parent.coordinate)

                D.dropObject({position, d.drop})
            end

            function d.update()
                if d.dropTime ~=nil then
                    d.progress.progress(DELTA)
                end
            end

        return d
    end

return D