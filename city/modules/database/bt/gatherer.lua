local BTree= {}

    BTree.name = "Gatherer"

    BTree.new = function(unit, resourceType)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = unit
            
            Tree.resourceType = resourceType
            Tree.honding = false

            Tree.target = nil
            Tree.onHisWay = false

            function Tree.setTarget(target)
                Tree.target = target
                Tree.onHisWay = false
            end

            local function setIdle()
                -- print("set idle R")
                -- UnitController.setIdle(Tree.unit, true)
                -- return Status.SUCCESS
            end

            local function noTarget()
                -- Tree.setTarget(nil)
                -- return Status.SUCCESS
            end

            local function hasTarget()                      -- TODO. WAAROM ZIJN HAS EN GET ALLEBEI SATEEDS FAILURE?!
                local has = Tree.target ~= nil
                if has == true then 
                    print("has SUCCESS")
                else
                    print("has FAILURE")
                end

                return BT.boolToStatus(has)
            end

            local function getNearestResource()
                local resource = ResourceController.findNearestResource(Tree.resourceType, Tree.unit.position, Tree.unit.maxDistance)
                if resource ~=nil then
                    unit.setTarget(resource)
                    Tree.target = resource
                    print("get SUCCESS")

                    return Status.SUCCESS
                end
                print("get FAILURE")

                return Status.FAILURE
            end

            local function targetExists()
                local u,i = ResourceController.getResource(Tree.target)
                return BT.boolToStatus(i ~= -1)
            end
            
            local function startMovingToTarget()
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

            local function gatherResource()
                print("gather")
                if targetExists() == Status.FAILURE then
                    return Status.FAILURE
                end
                print("resource bestaat")
                Tree.target.gather()  --gather rate
                if Tree.target.empty() then
                    ResourceController.removeResource(Tree.target)
                    Tree.holding = true
                    print("holding")
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local idle = BT.leaf("Idle state R", 1, setIdle, nil)
            local noTarget = BT.leaf("Set target to nothing R", 1, noTarget, nil)

            local hasTarget = BT.leaf("Has target? R", 1, hasTarget, nil)

            local detectResource = BT.leaf("Detect nearby resource of right type R", 1, getNearestResource, nil)
            local startMoving = BT.leaf("Start moving to target R", 1, startMovingToTarget, nil)

            local targetSelector = BT.selector("Target selector R", 1, {hasTarget, detectResource})

            local targetResourceExist = BT.leaf("Target resource exists? R", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target R", 1, moveToTarget, nil)
            local gather = BT.leaf("Gather resource R", 1, gatherResource, nil)
            local gatherSequence = BT.sequence("Gather sequence R", 1, {targetSelector, targetResourceExist, startMoving, moveTarget, gather, noTarget})

            -- TODO deliver sequence

            Tree.tree = BT.selector("Gatherer tree", 1, {gatherSequence, idle})
            Tree.tree.debug(0)

-- target zoeken, naar resource, dan pakken, storage zoeken, brengen, resource omhoog, nieuw target zoeken

        return Tree
    end
return BTree