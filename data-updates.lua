local misc = require("misc")
local rm = require("recipe-manipulation")
local tm = require("technology-manipulation")

if not (mods["BrassTacks"] or mods["IfNickel"] or mods["BrimStuff"] or mods["ThemTharHills"] or mods["LasingAround"]) then
    return
end
--This probably does not belong in a library mod but I dare you to find a better place for it.

local function best_item(items)
    for k, v in pairs(items) do
        if misc.GetPrototype(v[1]) then
            return v
        end
    end
end

local speed_item = best_item({{"express-gearbox", 1}, {"bearing", 5}, {"semiboloid-stator", 5}, {"drive-belt", 5}, {"electric-engine-unit", 1}})
local efficiency_item = best_item({{"heavy-cable", 1}, {"electromagnetic-coil", 5}, {"rubber", 10}, {"gold-plate", 5}, {data.raw.item["electroplating-machine"] and "tinned-cable" or "no-item-at-all", 10}, {"flywheel", 5}, {"battery", 5}})
local quality_item = best_item({{"scanner", 2}, {"laser", 2}, {"self-regulating-valve", 2}, {"gyro", mods["BrassTacks"] and 2 or 20}, {"transciever", 2}, {"fluid-regulator", 2}, {"high-pressure-valve", 2}, {"airtight-seal", 5}})
local productivity_item = best_item({{"complex-joint", 2}, {data.raw.item["scanner"] and "laser" or "no-item-at-all", 2}, {"motorized-arm", 5}, {"stepper-motor", 5}, {"differential-girdlespring", 2}, {"electric-motor", 5}})

if speed_item and efficiency_item and productivity_item and (quality_item or not mods["quality"]) then
    if mods["space-age"] then
        rm.AddIngredient("speed-module-2", speed_item[1], speed_item[2])
        rm.AddIngredient("efficiency-module-2", efficiency_item[1], efficiency_item[2])
        rm.AddIngredient("quality-module-2", quality_item[1], quality_item[2])
        rm.AddIngredient("productivity-module-2", productivity_item[1], productivity_item[2])
    else
        rm.AddIngredient("speed-module-3", speed_item[1], speed_item[2] * 5)
        rm.AddIngredient("efficiency-module-3", efficiency_item[1], efficiency_item[2] * 5)
        rm.AddIngredient("productivity-module-3", productivity_item[1], productivity_item[2] * 5)
        if mods["quality"] then
            rm.AddIngredient("quality-module-3", quality_item[1], quality_item[2] * 5)
        end
    end
end