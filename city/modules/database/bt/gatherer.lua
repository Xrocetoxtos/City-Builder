local BTree= {}

    BTree.name = "Gatherer"

    BTree.new = function(args)
        local Tree = {}
            Tree.name = BTree.name
            Tree.unit = args[1]
            
            Tree.resourceType = args[2]
            Tree.holding = false

            Tree.target = args[3]
            Tree.initialTarget = Tree.target

            Tree.onHisWay = false

            local function isHoldingResource()
                return BT.boolToStatus(Tree.holding)
            end

            local function getNearestResource()
                if Tree.initialTarget== nil then
                    Tree.initialTarget = Tree.unit
                end
                local resource = ResourceController.findNearestResource(Tree.resourceType, Tree.initialTarget.position, Tree.unit.maxDistance)

                if resource ~=nil then
                    SharedBT.setTarget({Tree, resource})
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function getNearestStorage()
                local resource = StorageController.findNearestStorage(Tree.resourceType, Tree.unit.position, Tree.unit.maxDistance)
                if resource ~=nil then
                    SharedBT.setTarget({Tree, resource})
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function targetExists()
                local u,i = ResourceController.getResource(Tree.target)
                return BT.boolToStatus(i ~= -1)
            end
            
            local function gatherResource()
                if targetExists() == Status.FAILURE then
                    return Status.FAILURE
                end
                Tree.target.gather()  --gather rate
                if Tree.target.gatherComplete() then
                    Tree.target.reduce(1)
                    if Tree.target.empty() then
                        ResourceController.removeResource(Tree.target)
                    end
                    Tree.holding = true
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local function dropResource()
                Tree.holding = false
                if Tree.resourceType == nil then return Status.FAILURE end
                local res = {}

                if Tree.resourceType.type == ResourceType.FOOD then res.food = 1 end
                if Tree.resourceType.type == ResourceType.WOOD then res.wood = 1 end
                if Tree.resourceType.type == ResourceType.GOLD then res.gold = 1 end
                if Tree.resourceType.type == ResourceType.STONE then res.stone = 1 end

                ResourceController.addResources(res)
                Tree.target = nil

                return Status.SUCCESS
            end

            local idle = BT.leaf("Idle state R", 1, SharedBT.setIdle, {Tree})
            local noTarget = BT.leaf("Set target to nothing R", 1, SharedBT.noTarget, {Tree})

            local hasTarget = BT.leaf("Has target? R", 1, SharedBT.hasTarget, {Tree})

            local isHolding = BT.leaf("Is holding resource?", 1, isHoldingResource, nil)
            local notHolding = BT.inverter("Is not holding resource", 1, isHolding)

            local detectResource = BT.leaf("Detect nearby resource of right type R", 1, getNearestResource, nil)
            local startMoving = BT.leaf("Start moving to target R", 1, SharedBT.startMovingToTarget, {Tree})

            local targetSelector = BT.selector("Target selector R", 1, {hasTarget, detectResource})

            local targetResourceExist = BT.leaf("Target resource exists? R", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target R", 1, SharedBT.moveToTarget, {Tree})
            local gather = BT.leaf("Gather resource R", 1, gatherResource, nil)
            local gatherSequence = BT.sequence("Gather sequence R", 1, {notHolding, targetSelector, targetResourceExist, startMoving, moveTarget, gather, noTarget})
            
            local detectStorage = BT.leaf("Target nearby storage of right type", 1, getNearestStorage, nil)
            local dropAtStorage = BT.leaf("Drop resource at storage", 1, dropResource, nil)
            local selectStorage = BT.selector("Storage selector", 1, {hasTarget, detectStorage})
            local deliverSequence = BT.sequence("Deliver Sequence", 1, {isHolding, selectStorage, startMoving, moveTarget, dropAtStorage, noTarget})

            Tree.tree = BT.selector("Gatherer tree", 1, {gatherSequence, deliverSequence, idle})
            Tree.tree.debug(0)

        return Tree
    end

return BTree