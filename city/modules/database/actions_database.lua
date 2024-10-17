ActionType = {
    UNIT = "Unit",
    TECH = "Tech",
    UPGRADE = "Upgrade"
}

AD = {}

    AD.recruitUnit = {
        name = "Recruit Unit",
        icon = nil,
        resource = {
            wood = 5,
            gold = 5,
            stone = 0,
            food = 20,
            population = 1
        },       
        requiredTech = "Tech",
        stackable = true,
        progressTime = 10,
        type = ActionType.UNIT,
        followUp = {}
    }

    AD.researchTech = {
        name = "Research Tech",
        icon = nil,
        resource = {
            wood = 0,
            gold = 10,
            stone = 0,
            food = 10,
        }, 
        requiredTech = nil,
        stackable = false,
        progressTime = 10,
        type = ActionType.TECH,
        researchTech = "Tech",
        followUp = {}
    }

    AD.researchTest = {
        name = "Test Tech",
        icon = nil,
        resource = {
            wood = 0,
            gold = 0,
            stone = 0,
            food = 20,
        }, 
        requiredTech = nil,
        stackable = false,
        progressTime = 10,
        type = ActionType.TECH,
        researchTech = "Tech",
        followUp = {}
    }

return AD