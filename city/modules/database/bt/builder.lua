local BTree= {}

    BTree.name = "Builder"

    BTree.new = function(args)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = args[1]
            Tree.target = nil
            Tree.onHisWay = false

            local function getNearestPendingBuilding()
                local building = BuildingController.findNearestPendingBuilding(Tree.unit.position, Tree.unit.maxDistance)
                if building ~=nil then
                    SharedBT.setTarget({Tree, building})
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function targetExists()
                local u, i = BuildingController.getPendingBuilding(Tree.target)
                return BT.boolToStatus(i ~= -1)
            end

            local function buildBuilding()
                if targetExists() == Status.FAILURE then
                    return Status.FAILURE
                end
                Tree.target.build(10)
                if Tree.target.finished then
                    BuildingController.removePendingBuilding(Tree.target)
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local idle = BT.leaf("Idle state", 1, SharedBT.setIdle, {Tree})
            local noTarget = BT.leaf("Set target to nothing", 1, SharedBT.noTarget, {Tree})

            local hasTarget = BT.leaf("Has target?", 1, SharedBT.hasTarget, {Tree})

            local detectPending = BT.leaf("Detect nearby pending building", 1, getNearestPendingBuilding, nil)
            local startMoving = BT.leaf("Start moving to target", 1, SharedBT.startMovingToTarget, {Tree})

            local targetSelector = BT.selector("Target selector", 1, {hasTarget, detectPending})

            local targetBuildingExists = BT.leaf("Target building exists?", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target", 1, SharedBT.moveToTarget, {Tree})
            local build = BT.leaf("Build building", 1, buildBuilding, nil)
            local buildSequence = BT.sequence("Build sequence", 1, {targetSelector, targetBuildingExists, startMoving, moveTarget, build, noTarget})

            Tree.tree = BT.selector("builder tree", 1, {buildSequence, idle})
            Tree.tree.debug(0)
        return Tree
    end
return BTree