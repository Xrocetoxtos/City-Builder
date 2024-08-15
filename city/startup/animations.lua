local animations = {}

    animations.ui = {}
        local grid = Anim8.newGrid(32,32,Sprites.ui.bonePointer:getWidth(), Sprites.ui.bonePointer:getHeight())
        animations.ui.bonePointerAnimation = Anim8.newAnimation(grid('1-2',1), 0.4)

return animations