local RA = {}

    function RA.finishAction (runningaction)
        runningaction.progress.complete()
        local can = runningaction.canComplete()

        if can == false then -- check of we verder kunnen. anders volgend frame checken
            return
        end

        if runningaction.action.type == ActionType.TECH then
            TechController.discover(runningaction.action.researchTech)
            TechController.stopResearching(runningaction.action.researchTech)
        elseif runningaction.action.type == ActionType.UNIT then
            local placed = UnitController.recruitUnit(runningaction.building.coordinate)
            if placed==false then
                GuiController.setMessage("Unable to recruit unit around ".. runningaction.building.data.name.. ".")
                return          -- kan unit niet plaatsen. dan wachten tot plek beschikbaar komt
            end
        elseif runningaction.action.type == ActionType.UPGRADE then
            UpgradeController.setFinished(runningaction.action.researchUpgrade)
            UpgradeController.unsetPending(runningaction.action.researchUpgrade)
        else
            print("Action type is wrong.")
        end

        runningaction.active = false
        runningaction.building.removeRunningAction(runningaction.action)
        runningaction.building.activateRunningActions()
        SelectedObjectDisplay.setup(SelectedObjectDisplay.currentBuilding)
    end

    function RA.new(building, action)
        local R = {}

            R.building = building
            R.action = action

            R.progress = Progress.new(R, action.progressTime,RA.finishAction, R)
            R.active = false

            function R.setActive()
                R.active = true
                if R.action.type == ActionType.TECH then
                    TechController.research(R.action.researchTech)
                elseif R.action.type ==ActionType.UPGRADE then
                    UpgradeController.setPending(R.action.researchUpgrade)
                end
            end

            function R.update(dt)
                if R.active == true then
                    R.progress.progress(dt)
                end
            end

            function R.canComplete()
                if R.action.type == ActionType.UNIT then
                    local population = ResourceController.hasPopulationSpace(R.action.resource.population)
                    if population == false then
                        GuiController.setMessage("Not enough population space to recruit another villager.")
                        return false
                    end
                end 
                return true
            end

        return R
    end

return RA
