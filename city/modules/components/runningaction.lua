local RA = {}

    function RA.finishAction (runningaction)
        --TODO uitvoeren van de betreffende actie, dus tech, recruit of Upgrade
        runningaction.progress.complete()
        if not runningaction.canComplete() then -- check of we verder kunnen. anders volgend frame checken
            return
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