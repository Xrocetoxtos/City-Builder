local BTree= {}

    BTree.name = "Gatherer"

    BTree.new = function(args)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = args[1]
            
            Tree.resourceType = args[2]
            Tree.holding = false

            Tree.target = args[3]
            Tree.onHisWay = false

            function Tree.setTarget(target)
                Tree.target = target
                Tree.onHisWay = false
            end

            local function setIdle()
                -- print("set idle R")
                -- UnitController.setIdle(Tree.unit, true)
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

            local function isHoldingResource()
                return BT.boolToStatus(Tree.holding)
            end

            local function getNearestResource()
                local resource = ResourceController.findNearestResource(Tree.resourceType, Tree.unit.position, Tree.unit.maxDistance)
                if resource ~=nil then
                    unit.setTarget(resource)
                    Tree.target = resource
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function getNearestStorage()
                local resource = StorageController.findNearestStorage(Tree.resourceType, Tree.unit.position, Tree.unit.maxDistance)
                print("storage")
                print(resource)
                if resource ~=nil then
                    Tree.unit.setTarget(resource)
                    Tree.target = resource
                    return Status.SUCCESS
                end
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
                if targetExists() == Status.FAILURE then
                    return Status.FAILURE
                end
                Tree.target.gather()  --gather rate
                if Tree.target.empty() then
                    ResourceController.removeResource(Tree.target)
                    Tree.holding = true
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local function dropResource()
                return Status.SUCCESS
            end

            local idle = BT.leaf("Idle state R", 1, setIdle, nil)
            local noTarget = BT.leaf("Set target to nothing R", 1, noTarget, nil)

            local hasTarget = BT.leaf("Has target? R", 1, hasTarget, nil)

            local isHolding = BT.leaf("Is holding resource?", 1, isHoldingResource, nil)
            local notHolding = BT.inverter("Is not holding resource", 1, isHolding)

            local detectResource = BT.leaf("Detect nearby resource of right type R", 1, getNearestResource, nil)
            local startMoving = BT.leaf("Start moving to target R", 1, startMovingToTarget, nil)

            local targetSelector = BT.selector("Target selector R", 1, {hasTarget, detectResource})

            local targetResourceExist = BT.leaf("Target resource exists? R", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target R", 1, moveToTarget, nil)
            local gather = BT.leaf("Gather resource R", 1, gatherResource, nil)
            local gatherSequence = BT.sequence("Gather sequence R", 1, {notHolding, targetSelector, targetResourceExist, startMoving, moveTarget, gather, noTarget})
            
            local detectStorage = BT.leaf("Target nearby storage of right type", 1, getNearestStorage, nil)
            local dropAtStorage = BT.leaf("Drop resource at storage", 1, dropResource, nil)
            local selectStorage = BT.selector("Storage selector", 1, {hasTarget, detectStorage})
            local deliverSequence = BT.sequence("Deliver Sequence", 1, {isHolding, selectStorage, startMoving, moveTarget, dropAtStorage, noTarget})

            Tree.tree = BT.selector("Gatherer tree", 1, {gatherSequence, deliverSequence, idle})
            Tree.tree.debug(0)

-- target zoeken, naar resource, dan pakken, storage zoeken, brengen, resource omhoog, nieuw target zoeken

        return Tree
    end
return BTree