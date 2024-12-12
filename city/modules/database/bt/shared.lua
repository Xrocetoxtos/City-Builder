local S = {}

    function S.setTarget(args)
        print("settarget")
        local tree = args[1]
        local target = args[2]
        tree.target = target
        tree.onHisWay = false
    end

    function S.setIdle(args)
        print("setidle")
        local tree = args[1]
        print("set idle R")
        UnitController.setIdle(tree.unit, true)
        return Status.SUCCESS
    end

    function S.noTarget(args)
        print("noTarget")
        print(args[1])

        local tree = args[1]
        -- tree.setTarget(nil)
        S.setTarget({tree, nil})
        return Status.SUCCESS
    end

    function S.hasTarget(args)
        print("hartarget")

        local tree = args[1]
        local has = tree.target ~= nil
        return BT.boolToStatus(has)
    end

return S