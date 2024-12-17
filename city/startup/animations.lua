local animations = {}

    animations.ui = {}
        local grid = Anim8.newGrid(16,16,Sprites.ui.bonePointer:getWidth(), Sprites.ui.bonePointer:getHeight())
        animations.ui.bonePointerAnimation = Anim8.newAnimation(grid('1-2',1), 0.4)

        animations.villager = {}
        local grid = Anim8.newGrid(16,16,Sprites.villager:getWidth(), Sprites.villager:getHeight())
        animations.villager.idle = Anim8.newAnimation(grid('1-2',1), 0.4)
        animations.villager.walkLR = Anim8.newAnimation(grid('1-4',2), 0.2)
        animations.villager.walkRL = animations.villager.walkLR:clone()
        animations.villager.walkRL:flipH()
        animations.villager.walkUD = Anim8.newAnimation(grid('1-4',3), 0.2)
        animations.villager.walkDU = animations.villager.walkUD:clone()

return animations