local ITree= {}

    ITree.name = "Idle"

    ITree.new = function(unit)
        local IdleTree = {}
        IdleTree.name = ITree.name

            local beIdle = function()
                return Status.SUCCESS
            end
            local idle = BT.leaf("Idle state", 1, beIdle, nil)

            
            IdleTree.tree = BT.selector("Idle tree", 1, { idle})
            IdleTree.tree.debug(0)
        return IdleTree
    end
return ITree