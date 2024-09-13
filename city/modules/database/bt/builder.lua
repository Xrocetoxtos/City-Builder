local BTree= {}

    BTree.new = function(unit)
        local BuilderTree = {}
            BuilderTree.parent = unit
            BuilderTree.target = nil

            local function setIdle()
                -- idle animation voor BuilderTree.parent
                print("idle")
                return Status.SUCCESS
            end

            local function getNearestPendingBuilding()
                local building = BuildingController.findNearestPendingBuilding(BuilderTree.parent.position, BuilderTree.parent.maxDistance)
                if building ~=nil then
                    unit.setTarget(building)
                    BuilderTree.target = building
                    return Status.SUCCESS
                end
                return Status.FAILURE
            end

            local function targetExists()
                -- TODO: BuilderTree.target bestaat en is nog niet afgebouwd    
                return Status.SUCCESS
            end

            local function moveToTarget()
                if BuilderTree.parent.targetReached() then
                    return Status.SUCCESS
                end
                return Status.RUNNING
            end

            local function buildBuilding()
                if not targetExists() then
                    return Status.FAILURE
                end
                BuilderTree.target.build(10)
                print(BuilderTree.target.showInfo())
                if BuilderTree.target.finished then
                    return Status.SUCCESS
                end
                -- TODO: buildingtellertje ophogen
                -- als gedaan: success en weghalen  building van lijst controller
                -- als bezig: running
                return Status.RUNNING
            end

            local idle = BT.leaf("Idle state", 1, setIdle, nil)

            local detectPending = BT.leaf("Detect nearby pending building", 1, getNearestPendingBuilding, nil)
            local targetBuildingExists = BT.leaf("Target building exists?", 1, targetExists, nil)
            local moveTarget = BT.leaf("Move to target", 1, moveToTarget, nil)
            local build = BT.leaf("Build building", 1, buildBuilding, nil)
            local buildSequence = BT.sequence("Build sequence", 1, {detectPending, targetBuildingExists, moveTarget, build})

            BuilderTree.tree = BT.selector("builder tree", 1, {buildSequence, idle})
            BuilderTree.tree.debug(0)
        return BuilderTree
    end
return BTree