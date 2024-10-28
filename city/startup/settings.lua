local settings = {}

    function settings.load(file)
        if file == nil then
            settings.quit = "escape"

            settings.select = {}
            settings.select.multi = {"rshift", "lshift"}
            settings.select.idle = "i"
            settings.select.controlGroup = { "1","2","3","4","5","6","7","8","9","0"}
            settings.select.controlGroupSelect = {"lctrl","rctrl"}

            settings.building = {}
            settings.building.multi = {"rshift", "lshift"}

            settings.camera = {}
            settings.camera.moveSpeed = 100
            settings.camera.panMargin = 50
            settings.camera.left = {"a", "left"}
            settings.camera.right = {"d", "right"}
            settings.camera.up = {"w", "up"}
            settings.camera.down = {"s", "down"}
        else
            -- TODO read from a file
        end
    end

    function settings.save()
        
    end



return settings