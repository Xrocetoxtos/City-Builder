local BD = {

    {
        name = "Town Center",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 5,
        sprites = {

        }, 
        resource = {
            wood = 300,
            gold = 300,
            stone = 300,
            food = 300
        },
        requiredTech = {

        },
        actions = {
            ActionsDatabase.recruitUnit, ActionsDatabase.researchTech
        }
    },

    {
        name = "House",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 2,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {
            "Tech"
        },
        actions = {}
    },

    {
        name = "Granary",
        type = "Civic",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        actions = {}
    },

    {
        name = "Barracks",
        type = "Military",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        actions = {}
    },
 
    {
        name = "Blacksmith",
        type = "Industrial",
        icon = nil,
        ghost = nil,
        population = 0,
        sprites = {

        }, 
        resource = {
            wood = 30,
            gold = 10,
            stone = 20,
            food = 20
        },
        requiredTech = {

        },
        actions = {}
    }
}

return BD
