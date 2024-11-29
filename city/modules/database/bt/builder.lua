local BTree= {}

    BTree.name = "Builder"

    BTree.new = function(args)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = args[1]
            Tree.target = nil
            Tree.onHisWay = false

            function Tree.setTarget(target)
                Tree.target = target
                Tree.onHisWay = false
            end

            local function setIdle()
                -- idle animation voor BuilderTree.parent
                UnitController.setIdle(Tree.unit, true)
                return Status.SUCCESS
            end

            local function noTarget()
                Tree.setTarget(nil)
                return Status.SUCCESS
            end

            local function hasTarget()
                local has = Tree.target ~= nil
                return BT.boolToStatus(has)
            end

            local function getNearestPendingBuilding()
                local building = BuildingController.findNearestPendingBuilding(Tree.unit.position, Tree.unit.maxDistance)
                if building ~=nil then
                    Tree.unit.setTarget(building)
                    Tree.target = building
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function targetExists()
                local u, i = BuildingController.getPendingBuilding(Tree.target)
                
                return BT.boolToStatus(i ~= -1)
            end
            
            local function startMovingToTarget()                --TODO: zorgen dat je op een plek naast het target komt te staan waar nog niemand zit
                UnitController.setIdle(Tree.unit, false)
                if Tree.target == nil then return Status.FAILURE end
                if Tree.onHisWay == false then
                    UnitOrders.setTarget(Tree.target, Tree.target.coordinate)
                    Tree.unit.setPathTowards(Tree.target.coordinate)
                    Tree.onHisWay= true
                end
                return Status.SUCCESS
            end

            local function moveToTarget()
                if Tree.unit.targetReached() then
                    return Status.SUCCESS
                end
                return Status.RUNNING
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

            local idle = BT.leaf("Idle state", 1, setIdle, nil)
            local noTarget = BT.leaf("Set target to nothing", 1, noTarget, nil)

            local hasTarget = BT.leaf("Has target?", 1, hasTarget, nil)

            local detectPending = BT.leaf("Detect nearby pending building", 1, getNearestPendingBuilding, nil)
            local startMoving = BT.leaf("Start moving to target", 1, startMovingToTarget, nil)

            local targetSelector = BT.selector("Target selector", 1, {hasTarget, detectPending})

            local targetBuildingExists = BT.leaf("Target building exists?", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target", 1, moveToTarget, nil)
            local build = BT.leaf("Build building", 1, buildBuilding, nil)
            local buildSequence = BT.sequence("Build sequence", 1, {targetSelector, targetBuildingExists, startMoving, moveTarget, build, noTarget})

            Tree.tree = BT.selector("builder tree", 1, {buildSequence, idle})
            Tree.tree.debug(0)
        return Tree
    end
return BTree