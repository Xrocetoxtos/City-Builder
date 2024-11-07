local RA = {}

    function RA.finishRunningAction (runningaction)
        runningaction.progress.complete()
        local can = runningaction.canComplete()

        if can == false then -- check of we verder kunnen. anders volgend frame checken
            return
        end

        RA.finishAction(runningaction.action, runningaction.building)
        runningaction.active = false
        runningaction.building.removeRunningAction(runningaction.action)
        runningaction.building.activateRunningActions()
        SelectedObjectDisplay.setup(SelectedObjectDisplay.currentBuilding)
    end

    function RA.finishAction(action, building)
        if action.type == ActionType.TECH then
            TechController.discover(action.researchTech)
            TechController.stopResearching(action.researchTech)
        elseif action.type == ActionType.UNIT then
            local placed = UnitController.recruitUnit(building.coordinate)
            if placed==false then
                GuiController.setMessage("Unable to recruit unit around ".. building.data.name.. ".")
                return          -- kan unit niet plaatsen. dan wachten tot plek beschikbaar komt
            end
        elseif action.type == ActionType.UPGRADE then
            UpgradeController.setFinished(action.researchUpgrade)
            UpgradeController.unsetPending(action.researchUpgrade)
        else
            print("Action type is wrong.")
        end
        RA.runFollowUps(action, building)
    end

    function RA.runFollowUps(action, building)
        for index, actie in ipairs(action.followUp) do
            RA.finishAction(actie, building)
        end
    end

    function RA.new(building, action)
        local R = {}

            R.building = building
            R.action = action

            R.progress = Progress.new(R, action.progressTime,RA.finishRunningAction, R)
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
