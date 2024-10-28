local function keyInTable(key, tab)
    if key == nil or tab == nil then return false end
    
    for i = 1,#tab, 1 do
        if key == tab[i] then return true end
    end
    return false
end

function love.keyreleased(key)
    if key == Settings.quit then
        love.event.quit()
    end
    if key == Settings.select.idle then
        UnitSelector.nextIdle()
    end

    if keyInTable(key, Settings.select.controlGroup) then
        UnitSelector.controlGroup(key)
    end
end

