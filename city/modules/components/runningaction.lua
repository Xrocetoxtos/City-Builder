local RA = {}

    function RA.finishAction (runningaction)
        runningaction.progress.complete()
        local can = runningaction.canComplete()
        print(can)

        if can == false then -- check of we verder kunnen. anders volgend frame checken
            return
        end
        --TODO uitvoeren van de betreffende actie, dus tech, recruit of Upgrade
        if runningaction.action.type == ActionType.TECH then
            TechController.discover(runningaction.action.researchTech)
        elseif runningaction.action.type == ActionType.UNIT then
            local placed = UnitController.recruitUnit(runningaction.building.coordinate)
            if placed==false then
                GuiController.setMessage("Unable to recruit unit around ".. runningaction.building.data.name.. ".")
                return          -- kan unit niet plaatsen. dan wachten tot plek beschikbaar komt
            end
        elseif runningaction.action.type == ActionType.UPGRADE then

        else
            print("Action type is wrong.")
        end

        runningaction.active = false
        runningaction.building.removeRunningAction(runningaction.action)
        runningaction.building.activateRunningActions()
    end

    function RA.new(building, action)
        local R = {}

            R.building = building
            R.action = action

            R.progress = Progress.new(R, action.progressTime,RA.finishAction, R)
            R.active = false

            function R.setActive()
                R.active = true
            end

            function R.update(dt)
                if R.active == true then
                    R.progress.progress(dt)
                end
            end

            function R.canComplete()
                if R.action.type == ActionType.UNIT then
                    return ResourceController.hasPopulationSpace(R.action.resource.population)
                end 
                return true
            end

        return R
    end

return RA
