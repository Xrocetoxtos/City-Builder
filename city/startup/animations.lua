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
        animations.villager.walkUD = Anim8.newAnimation(grid('5-8',2), 0.2)
        animations.villager.walkDU = animations.villager.walkUD:clone()

        animations.villager.pickLR = Anim8.newAnimation(grid('1-4',3), 0.2)
        animations.villager.pickRL = animations.villager.pickLR:clone()
        animations.villager.pickRL:flipH()
        animations.villager.pickUD = Anim8.newAnimation(grid('5-8',3), 0.2)
        animations.villager.pickDU = animations.villager.pickUD:clone()

        animations.villager.axeLR = Anim8.newAnimation(grid('1-4',4), 0.2)
        animations.villager.axekRL = animations.villager.axeLR:clone()
        animations.villager.axekRL:flipH()
        animations.villager.axeUD = Anim8.newAnimation(grid('5-8',4), 0.2)
        animations.villager.axeDU = animations.villager.axeUD:clone()

        animations.villager.hammerLR = Anim8.newAnimation(grid('1-4',5), 0.2)
        animations.villager.hammerRL = animations.villager.hammerLR:clone()
        animations.villager.hammerRL:flipH()
        animations.villager.hammerUD = Anim8.newAnimation(grid('5-8',5), 0.2)
        animations.villager.hammerDU = animations.villager.hammerUD:clone()

return animations