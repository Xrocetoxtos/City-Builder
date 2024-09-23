local ITree= {}

    ITree.name = "Idle"

    ITree.new = function(unit)
        local IdleTree = {}
        IdleTree.name = ITree.name
        IdleTree.unit =  unit

            local beIdle = function()
                print("idle")
                UnitController.setIdle(IdleTree.unit, true)
                return Status.SUCCESS
            end

            local idle = BT.leaf("Idle state", 1, beIdle, nil)
            
            IdleTree.tree = BT.selector("Idle tree", 1, { idle})
            IdleTree.tree.debug(0)
        return IdleTree
    end
return ITree