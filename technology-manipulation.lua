local tm = {}

local function AddPrerequisite(tech, prereq)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if tech.prerequisites then
        for k, v in pairs(tech.prerequisites) do
            if v == prereq then
                return
            end
        end
        table.insert(tech.prerequisites, prereq)
    else
        tech.prerequisites = {prereq}
    end
end

local function RemovePrerequisite(tech, prereq)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if tech.prerequisites then
        for k, v in pairs(tech.prerequisites) do
            if v == prereq then
                table.remove(tech.prerequisites, k)
                return
            end
        end
    end
end

--tech must be the name of a technology prototype or a technology prototype
--unlock must be the name of a recipe or a technology effect modifier
--after determines where to insert it in the list of unlocks, for aesthetic purposes.
--string: after the specified recipe, at the end if not found.
--string prefixed with -: directly before the specified recipe, at the start if not found.
--integer: at that index precisely.
--unset: at the end.
local function AddUnlock(tech, unlock, after)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if type(unlock) == "string" then
        unlock = {
            type = "unlock-recipe",
            recipe = unlock
        }
    end

    if not tech.effects then
        tech.effects = {unlock}
        return
    end

    local index = #tech.effects + 1
    local before = "ph'nglui mglwnafh cthulhu r'lyeh wgah'nagl fhtagn"

    if type(after) == int then
        index = after
    end
    if not after then
        after = "ph'nglui mglwnafh cthulhu r'lyeh wgah'nagl fhtagn"
    end
    if type(after) == "string" and string.sub(after, 1, 1) == "-" then
        before = string.sub(after, 2)
        after = "ph'nglui mglwnafh cthulhu r'lyeh wgah'nagl fhtagn"
        index = 1
    end

    for k, v in pairs(tech.effects) do
        local match = true
        if v.recipe == after then
            index = k + 1
        end
        if v.recipe == before then
            index = k
        end
        for k2, v2 in pairs(unlock) do
            if v2 ~= v[k2] then
                match = false
                break
            end
        end
        if match then
            return
        end
    end
    table.insert(tech.effects, index, unlock)
end

local function RemoveUnlock(tech, unlock)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if type(unlock) == "string" then
        unlock = {
            type = "unlock-recipe",
            recipe = unlock
        }
    end

    if tech.effects then
        for k, v in pairs(tech.effects) do
            local match = true
            for k2, v2 in pairs(unlock) do
                if v2 ~= v[k2] then
                    match = false
                    break
                end
            end
            if match then
                table.remove(tech.effects, k)
                return
            end
        end
    end
end

local function AddSciencePack(tech, pack)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if type(pack) == "string" then
        pack = {pack, 1}
    end

    --suppose we should also allow passing the output of a function that returns a properly formatted *recipe* ingredient
    if pack.name then
        pack = {pack.name, pack.amount or 1}
    end

    if tech.unit then
        if not tech.unit.ingredients then
            tech.unit.ingredients = {}
        end
        for k, v in pairs(tech.unit.ingredients) do
            if v[1] == pack[1] then
                v[2] = pack[2]
                return
            end
        end
        table.insert(tech.unit.ingredients, table.deepcopy(pack))
    end
end

local function RemoveSciencePack(tech, pack)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if type(pack) == "string" then
        pack = {pack, 1}
    end

    --suppose we should also allow passing the output of a function that returns a properly formatted *recipe* ingredient
    if pack.name then
        pack = {pack.name, pack.amount or 1}
    end

    if tech.unit then
        if not tech.unit.ingredients then
            tech.unit.ingredients = {}
        end
        for k, v in pairs(tech.unit.ingredients) do
            if v[1] == pack[1] then
                table.remove(tech.unit.ingredients, k)
                return
            end
        end
    end
end

local function SetTechnologyTrigger(tech, trigger, amount)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if type(trigger) == "string" then
        trigger = {
            type = "craft-item",
            item = trigger,
            amount = 1 or amount
        }
    end

    tech.research_trigger = trigger
    tech.unit = nil
end

local function SetTechnologyCost(tech, cost)
    if type(tech) == "string" then
        if data.raw.technology[tech] then
            tech = data.raw.technology[tech]
        else
            return
        end
    end

    if tech.unit then
        tech.unit.count = cost
    end
end

tm.AddPrerequisite = AddPrerequisite
tm.RemovePrerequisite = RemovePrerequisite
tm.AddUnlock = AddUnlock
tm.RemoveUnlock = RemoveUnlock
tm.AddSciencePack = AddSciencePack
tm.RemoveSciencePack = RemoveSciencePack
tm.SetTechnologyTrigger = SetTechnologyTrigger
tm.SetTechnologyCost = SetTechnologyCost

return tm