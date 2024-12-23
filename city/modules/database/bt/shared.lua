local S = {}

    function S.setTarget(args)
        local tree = args[1]
        local target = args[2]
        tree.target = target
        tree.onHisWay = false
    end

    function S.setIdle(args)
        local tree = args[1]
        UnitController.setIdle(tree.unit, true)
        return Status.SUCCESS
    end

    function S.noTarget(args)
        local tree = args[1]
        S.setTarget({tree, nil})
        return Status.SUCCESS
    end

    function S.hasTarget(args)
        local tree = args[1]
        local has = tree.target ~= nil
        return BT.boolToStatus(has)
    end

    function S.startMovingToTarget(args)
        local tree = args[1]
        UnitController.setIdle(tree.unit, false)
        if tree.target == nil then return Status.FAILURE end
        if tree.onHisWay == false then
            -- UnitOrders.setTarget(tree.target, tree.target.coordinate)
            UnitOrders.setTarget(tree.unit, tree.target.coordinate)
            tree.unit.setPathTowards(tree.target.coordinate)
            tree.onHisWay= true
        end
        return Status.SUCCESS
    end

    function S.moveToTarget(args)
        local tree = args[1]
        if tree.unit.targetReached() then
            return Status.SUCCESS
        end
        return Status.RUNNING
    end

return S
