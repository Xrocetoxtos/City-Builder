local UC = {}

    UC.pendingUpgrades = {}
    UC.finishedUpgrades = {}

    function UC.isPending(upgrade)
        for index, value in ipairs(UC.pendingUpgrades) do
            if value == upgrade then
                return index
            end          
        end
        return -1
    end

    function UC.setPending(upgrade)
        local index = UC.isPending(upgrade)
        if index == -1 then
            table.insert(UC.pendingUpgrades, upgrade)
        end
    end

    function UC.unsetPending(upgrade)
        local index = UC.isPending(upgrade)
        if index ~= -1 then
            table.remove(UC.pendingUpgrades, upgrade)
        end
    end

    function UC.isFinished(upgrade)
        for index, value in ipairs(UC.finishedUpgrades) do
            if value == upgrade then
                return index
            end          
        end
        return -1
    end

    function UC.setFinished(upgrade)
        local index = UC.isFinished(upgrade)
        if index == -1 then
            table.insert(UC.finishedUpgrades, upgrade)
        end
    end

    function UC.unsetFinished(upgrade)
        local index = UC.isFinished(upgrade)
        if index ~= -1 then
            table.remove(UC.finishedUpgrades, upgrade)
        end
    end
    
return UC