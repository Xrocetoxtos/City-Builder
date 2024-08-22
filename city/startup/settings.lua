local settings = {}

    function settings.load(file)
        if file == nil then
            settings.quit = "escape"

            settings.select = {}
            settings.select.multi = {"rshift", "lshift"}

            settings.camera = {}
            settings.camera.moveSpeed = 100
            settings.camera.panMargin = 50
            -- settings.camera.zoomSpeed = 0.2
            -- settings.camera.minZoom = 0.5
            -- settings.camera.maxZoom = 3
            settings.camera.left = {"a", "left"}
            settings.camera.right = {"d", "right"}
            settings.camera.up = {"w", "up"}
            settings.camera.down = {"s", "down"}
            -- settings.camera.zoomIn = "kp+"
            -- settings.camera.zoomOut = "kp-"
        else
            -- TODO read from a file
        end
    end

    function settings.save()
        
    end

return settings