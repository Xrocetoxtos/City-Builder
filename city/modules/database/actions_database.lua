ActionType = {
    UNIT = "Unit",
    TECH = "Tech",
    UPGRADE = "Upgrade"
}

AD = {}

    AD.recruitUnit = {
        name = "Recruit Villager",
        icon = nil,
        resource = {
            wood = 0,
            gold = 0,
            stone = 0,
            food = 0,
            population = 1
        },       
        requiredTech = "Tech",
        stackable = true,
        progressTime = 2,
        type = ActionType.UNIT,
        followUp = {}
    }

    AD.researchTech = {
        name = "Tech",
        icon = nil,
        resource = {
            wood = 0,
            gold = 10,
            stone = 0,
            food = 10,
        }, 
        requiredTech = nil,
        stackable = false,
        progressTime = 20,
        type = ActionType.TECH,
        researchTech = "Tech",
        followUp = {}
    }

    AD.researchTest = {
        name = "Tech2",
        icon = nil,
        resource = {
            wood = 0,
            gold = 0,
            stone = 0,
            food = 20,
        }, 
        requiredTech = nil,
        stackable = false,
        progressTime = 20,
        type = ActionType.TECH,
        researchTech = "Tech2",
        followUp = {}
    }

    AD.upgrade = {
        name = "Upgrade",
        icon = nil,
        resource = {
            wood = 0,
            gold = 0,
            stone = 0,
            food = 20,
        }, 
        requiredTech = nil,
        stackable = false,
        progressTime = 2,
        type = ActionType.UPGRADE,
        researchUpgrade = "Upgrade",
        followUp = {}
    }

return AD