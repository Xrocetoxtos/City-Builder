local kb = {}

    function kb.load(file)
        if file == nil then
            kb.quit = "escape"

            kb.select = {}
            kb.select.multi = {"rshift", "lshift"}

            kb.camera = {}
            kb.camera.moveSpeed = 100
            kb.camera.panMargin = 50
            kb.camera.left = {"a", "left"}
            kb.camera.right = {"d", "right"}
            kb.camera.up = {"w", "up"}
            kb.camera.down = {"s", "down"}
        else
            -- TODO read from a file
        end
    end

    function kb.save()
        
    end

return kb