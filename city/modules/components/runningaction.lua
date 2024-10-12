local RA = {}

    function RA.finishAction (runningaction)
        --TODO uitvoeren van de betreffende actie, dus tech, recruit of Upgrade
        --vervolgens R deleten bij runningaction en volgende met dezelfde action op active=true
        print("done")
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
                    R.progress.update(dt)
                end
            end

        return R
    end

return RA