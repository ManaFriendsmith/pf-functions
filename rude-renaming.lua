local rude_renaming = {}
local misc = require("misc")

rude_renaming.to_convert = {
    item = {},
    recipe = {},
    fluid = {},
    technology = {}
}

local function Convert(category, convert_from, convert_to)
    if rude_renaming.to_convert[category] then
        rude_renaming.to_convert[category][convert_from] = convert_to or false
    end
end

local function convert_item(convert_from, convert_to)
    local original = misc.GetPrototype(convert_from)
    if original then

        if original.spoil_result then
            if rude_renaming.to_convert.item[original.spoil_result] then
                original.spoil_result = rude_renaming.to_convert.item[original.spoil_result]
            end
        end
        if original.burnt_result then
            if rude_renaming.to_convert.item[original.burnt_result] then
                original.burnt_result = rude_renaming.to_convert.item[original.burnt_result]
            end
        end
        if original.rocket_launch_products then
            for k, v in pairs(original.rocket_launch_products) do
                if v.type == "item" and rude_renaming.to_convert.item[v.name] then
                    v.name = rude_renaming.to_convert.item[v.name]
                end
            end
        end

        if convert_to then
            original.name = convert_to
            data.raw[original.type][convert_from] = nil
            data:extend({original})
        end
    end
end

local function convert_recipe(convert_from, convert_to)
    local original = misc.GetPrototype(convert_from, "recipe")
    if original then

        if original.alternative_unlock_methods then
            for k, v in pairs(original.alternative_unlock_methods) do
                if rude_renaming.to_convert.technology[v] then
                    original.alternative_unlock_methods[k] = rude_renaming.to_convert.technology[v]
                end
            end
        end

        if original.main_product then
            if rude_renaming.to_convert.fluid[original.main_product] then
                original.main_product = rude_renaming.to_convert.fluid[original.main_product]
            end
            if rude_renaming.to_convert.item[original.main_product] then
                original.main_product = rude_renaming.to_convert.item[original.main_product]
            end
        end

        if original.ingredients then
            for k, v in pairs(original.ingredients) do
                if v.type == "item" and rude_renaming.to_convert.item[v.name] then
                    v.name = rude_renaming.to_convert.item[v.name]
                end
                if v.type == "fluid" and rude_renaming.to_convert.fluid[v.name] then
                    v.name = rude_renaming.to_convert.fluid[v.name]
                end
            end
        end

        if original.results then
            for k, v in pairs(original.results) do
                if v.type == "item" and rude_renaming.to_convert.item[v.name] then
                    v.name = rude_renaming.to_convert.item[v.name]
                end
                if v.type == "fluid" and rude_renaming.to_convert.fluid[v.name] then
                    v.name = rude_renaming.to_convert.fluid[v.name]
                end
            end
        end

        if convert_to then
            original.name = convert_to
            data.raw[original.type][convert_from] = nil
            data:extend({original})
        end
    end
end

local function convert_fluid(convert_from, convert_to)
    local original = misc.GetPrototype(convert_from, "fluid")
    if original then

        if convert_to then
            original.name = convert_to
            data.raw[original.type][convert_from] = nil
            data:extend({original})
        end
    end
end

local function convert_technology(convert_from, convert_to)
    local original = misc.GetPrototype(convert_from, "technology")
    if original then

        if original.prerequisites then
            for k, v in pairs(original.prerequisites) do
                if rude_renaming.to_convert.technology[v] then
                    original.prerequisites[k] = rude_renaming.to_convert.technology[v]
                end
            end
        end

        if original.research_trigger then
            if original.research_trigger.type == "craft-item" or original.research_trigger.type == "send-item-to-orbit" then
                if rude_renaming.to_convert.item[original.research_trigger.item] then
                    original.research_trigger.item = rude_renaming.to_convert.item[original.research_trigger.item]
                end
            end
        end

        if original.research_trigger then
            if original.research_trigger.type == "craft-fluid" then
                if rude_renaming.to_convert.fluid[original.research_trigger.fluid] then
                    original.research_trigger.fluid = rude_renaming.to_convert.fluid[original.research_trigger.fluid]
                end
            end
        end

        if original.unit and original.unit.ingredients then
            for k, v in pairs(original.unit.ingredients) do
                if rude_renaming.to_convert.item[v[1]] then
                    v[1] = rude_renaming.to_convert.item[v[1]]
                end
            end
        end

        if original.effects then
            for k, v in pairs(original.effects) do
                if v.item and rude_renaming.to_convert.item[v.item] then --give-item
                    v.item = rude_renaming.to_convert.item[v.item]
                end

                if v.recipe and rude_renaming.to_convert.recipe[v.recipe] then --unlock-recipe, change-recipe-productivity
                    v.recipe = rude_renaming.to_convert.recipe[v.recipe]
                end
            end
        end

        if convert_to then
            original.name = convert_to
            data.raw[original.type][convert_from] = nil
            data:extend({original})
        end
    end
end

local function Confirm()
    for k, v in pairs(rude_renaming.to_convert.item) do
        convert_item(k, v)
    end
    for k, v in pairs(rude_renaming.to_convert.fluid) do
        convert_fluid(k, v)
    end
    for k, v in pairs(rude_renaming.to_convert.recipe) do
        convert_recipe(k, v)
    end
    for k, v in pairs(rude_renaming.to_convert.technology) do
        convert_technology(k, v)
    end
end

local function Clear()
    rude_renaming.to_convert = {
    item = {},
    recipe = {},
    fluid = {},
    technology = {}
}
end

rude_renaming.Convert = Convert
rude_renaming.Confirm = Confirm
rude_renaming.Clear = Clear

return rude_renaming