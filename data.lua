--planetfall_lib = {}

--local mo = require("menu-organization")

--local old_extend = data.extend

--local function new_data_extend_func(self, otherdata)
--  if self ~= data and otherdata == nil then
--    otherdata = self
--  end
--  old_extend(otherdata)
--  for k, prototype in pairs(otherdata) do
--    if prototype.junk_drawer then
--        mo.process_new_prototype(prototype)
--    end
--  end
--end

--data.extend = new_data_extend_func

local misc = require("__pf-functions__/misc")

if settings.startup["planetfall-reorganize-crafting-menu"].value then
    data:extend({
        {
            type = "item-group",
            name = "resource-processing",
            order = "ba",
            icon = "__base__/graphics/technology/advanced-material-processing-2.png",
            icon_size = 256
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "metal-ore",
            order = "b"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "other-resource",
            order = "a"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "metal-plate",
            order = "c"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "alloy",
            order = "d"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "stone",
            order = "da"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "oil-fractions",
            order = "ea"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "solid-chemicals",
            order = "f"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "fluid-chemicals",
            order = "g"
        },
        {
            type = "item-subgroup",
            group = "resource-processing",
            name = "waste-processing",
            order = "h"
        },

        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "structural-components",
            order = "g-a"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "rotary-components",
            order = "g-b"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "engine-components",
            order = "g-c"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "cable",
            order = "g-d"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "electronic-gubbins",
            order = "g-e"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "circuits",
            order = "g-f"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "articulated-components",
            order = "g-g"
        },
        {
            type = "item-subgroup",
            group = "intermediate-products",
            name = "plumbing-components",
            order = "g-h"
        }
    })

    if mods["space-age"] then
        data:extend({
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "foundry-misc",
                order = "sa-a-a"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "foundry-vulcanus-resources",
                order = "sa-a-a"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "foundry-melting",
                order = "sa-a-b"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "foundry-casting-plates",
                order = "sa-a-c"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "foundry-casting-items",
                order = "sa-a-d"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "holmium",
                order = "sa-b-a"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "organic-raw-materials",
                order = "sa-c-a"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "biochemistry",
                order = "sa-c-b"
            },
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "bacteria",
                order = "sa-c-d"
            }
        })
    end

    if mods["bzcarbon"] then
        data:extend({
            {
                type = "item-subgroup",
                group = "resource-processing",
                name = "bz-carbon-processing",
                order = "f1"
            }
        })
    end
end