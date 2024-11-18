local BTree= {}

    BTree.name = "Gatherer"

    BTree.new = function(unit, resourceType)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = unit
            
            Tree.resourceType = resourceType    -- welk type moet ik gatheren
            Tree.amount = 0                     -- hoeveel heb ik nu vast

            Tree.target = nil
            Tree.onHisWay = false

            function Tree.setTarget(target)
                Tree.target = target
                Tree.onHisWay = false
            end

            local function setIdle()
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

            local function getNearestResource()
                -- local building = BuildingController.findNearestPendingBuilding(Tree.unit.position, Tree.unit.maxDistance)
                local resource = ResourceController.findNearestResource(Tree.resourceType)
                if resource ~=nil then
                    unit.setTarget(resource)
                    Tree.target = resource
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function targetExists()
                -- local u, i = BuildingController.getPendingBuilding(Tree.target)
                local u,i = ResourceController.getResource(Tree.target)
                
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

            -- local function buildBuilding()      -- gather
            --     if not targetExists() then
            --         return Status.FAILURE
            --     end
            --     Tree.target.build(10)
            --     if Tree.target.finished then
            --         BuildingController.removePendingBuilding(Tree.target)
            --         return Status.SUCCESS
            --     end
            --     return Status.RUNNING
            -- end

            local function gatherResource()
                if targetExists() == Status.FAILURE then
                    return Status.FAILURE
                end

                Tree.target.gather(10)  --gather rate`
                if Tree.target.empty() then
                    ResourceController.removeResource(Tree.target)
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local idle = BT.leaf("Idle state", 1, setIdle, nil)
            local noTarget = BT.leaf("Set target to nothing", 1, noTarget, nil)

            local hasTarget = BT.leaf("Has target?", 1, hasTarget, nil)

            local detectResource = BT.leaf("Detect nearby resource of right type", 1, getNearestResource, nil)
            local startMoving = BT.leaf("Start moving to target", 1, startMovingToTarget, nil)

            local targetSelector = BT.selector("Target selector", 1, {hasTarget, detectResource})

            local taegetResourceExist = BT.leaf("Target resource exists?", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target", 1, moveToTarget, nil)
            local gather = BT.leaf("Gather resource", 1, gatherResource, nil)
            local gatherSequence = BT.sequence("Gather sequence", 1, {targetSelector, taegetResourceExist, startMoving, moveTarget, gather, noTarget})

            -- TODO deliver sequence

            Tree.tree = BT.selector("Gatherer tree", 1, {gatherSequence, idle})
            Tree.tree.debug(0)

-- target zoeken, naar resource, dan pakken, storage zoeken, brengen, resource omhoog, nieuw target zoeken

        return Tree
    end
return BTree