function love.keyreleased(key)
    if key == Settings.quit then
        love.event.quit()
    end
    if key == Settings.select.idle then
        UnitSelector.nextIdle()
    end
end