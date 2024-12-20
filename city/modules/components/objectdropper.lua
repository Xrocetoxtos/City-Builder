local D = {}

    function D.dropObject(args)
        local position = args[1]
        local drop = args[2]
        local d = args[3]

        if d.progress ~= nil then
            position = ResourceController.findDropLocation(position)
        end

        if position ~= nil then
            ResourceController.addResource(position, drop)
        end
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
                    d.progress = Progress.new(parent, dropTime, D.dropObject, {d.parent.coordinate, drop, d} )
                end
            end

            function d.dropObject()
                D.dropObject({d.parent.position, d.drop})
            end

            function d.update()
                if d.dropTime ~=nil then
                    d.progress.progress(DELTA)
                end
            end

        return d
    end

return D