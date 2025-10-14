if settings.startup["planetfall-reorganize-crafting-menu"].value then
    local function count_items(list)
        local count = 0
        for k, v in pairs(list) do
            if data.raw.item[v] or data.raw.recipe[v] then
                count = count + 1
            end
        end
        return count
    end

    local function move(name, subgroup, order)
        if data.raw.item[name] then
            data.raw.item[name].subgroup = subgroup
            data.raw.item[name].order = order
        end
        if data.raw.capsule[name] then
            data.raw.capsule[name].subgroup = subgroup
            data.raw.capsule[name].order = order
        end
        if data.raw.recipe[name] then
            data.raw.recipe[name].subgroup = subgroup
            data.raw.recipe[name].order = order
        end
    end

    local function move_item(name, subgroup, order)
        if data.raw.item[name] then
            data.raw.item[name].subgroup = subgroup
            data.raw.item[name].order = order
        end
    end

    local function move_recipe(name, subgroup, order)
        if data.raw.recipe[name] then
            data.raw.recipe[name].subgroup = subgroup
            data.raw.recipe[name].order = order
        end
    end

    local function move_subgroup(name, group, order)
        if data.raw["item-subgroup"][name] then
            data.raw["item-subgroup"][name].group = group
            data.raw["item-subgroup"][name].order = order
        end
    end

    move_subgroup("helium", "resource-processing", "e")
    move_subgroup("uranium-processing", "resource-processing", "z")
    move_subgroup("intermediate-product", "intermediate-products", "i")
    move_subgroup("electroplating", "intermediate-products", "g")

    data.raw.capsule["raw-fish"].subgroup = "capsule"
    data.raw.capsule["raw-fish"].order = "z"

    move("wood", "other-resource", "a")
    move("coal", "other-resource", "b")
    move("stone", "other-resource", "c")
    move("flake-graphite", "other-resource", "d")
    move("rough-diamond", "other-resource", "e")
    move("zircon", "other-resource", "f")
    move("aop-deep-mineral", "other-resource", "g")
    move("aop-refined-mineral", "other-resource", "h")


    move("uranium-ore", "uranium-processing", "a")

    if data.raw.fluid["fertilizer-slurry"] then
        move("wood", "brimstuff-botany", "")
        if mods["space-age"] then
            move_subgroup("brimstuff-botany", "resource-processing", "r")
        else
            move_subgroup("brimstuff-botany", "resource-processing", "db")
        end
    end

    move("iron-ore", "metal-ore", "a")
    move("copper-ore", "metal-ore", "b")
    move("zinc-ore", "metal-ore", "c")
    move("nickel-ore", "metal-ore", "d")
    move("lead-ore", "metal-ore", "e")
    move("tin-ore", "metal-ore", "f")
    move("gold-ore", "metal-ore", "g")
    move("gold-powder", "metal-ore", "ga")
    move("titanium-ore", "metal-ore", "h")

    move("iron-plate", "metal-plate", "a")
    move("copper-plate", "metal-plate", "b")
    move("zinc-plate", "metal-plate", "c")
    move("nickel-plate", "metal-plate", "d")
    move("lead-plate", "metal-plate", "e")
    move("tin-plate", "metal-plate", "f")
    move("gold-plate", "metal-plate", "g")
    move("titanium-plate", "metal-plate", "h")

    if count_items({"steel-plate", "bronze-plate", "brass-plate", "invar-plate", "nitinol-plate", "cermet", "zircaloy-4"}) >= 3 then
        move("brass-precursor", "alloy", "a")
        move("brass-plate", "alloy", "aa")
        move("bronze-plate", "alloy", "b")
        move("invar-precursor", "alloy", "c")
        move("invar-plate", "alloy", "ca")
        move("steel-plate", "alloy", "d")
        move("zircaloy-4", "alloy", "e")
        move("cermet", "alloy", "ea")
        move("nitinol-precursor", "alloy", "n")
        move("nitinol-plate", "alloy", "na")
        move("nitinol-plate-in-space", "alloy", "nb")
    else
        move("brass-precursor", "metal-ore", "ca")
        move("invar-precursor", "metal-ore", "da")
        move("steel-plate", "metal-plate", "aa")
        move("brass-plate", "metal-plate", "ca")
        move("invar-plate", "metal-plate", "da")
        move("bronze-plate", "metal-plate", "fa")
        move("zircaloy-4", "metal-plate", "fb")
        move("cermet", "solid-chemicals", "ca")
    end

    move("zirconia", "solid-chemicals", "c")
    move("zirconium-sponge", "solid-chemicals", "ca")
    move("zirconium-plate", "solid-chemicals", "cb")
    move("potassium-nitrate", "solid-chemicals", "d")
    move("sulfur", "solid-chemicals", "e")
    move("coal-synthesis", "solid-chemicals", "f")
    move("gunpowder", "solid-chemicals", "g")
    move("rubber", "solid-chemicals", "h")
    move("toluene", "solid-chemicals", "i") --lies, damned lies, and statistics!!!
    move("tnt", "solid-chemicals", "j")
    move("explosives", "solid-chemicals", "k")
    move("plastic-bar", "solid-chemicals", "l")

    move("ice-melting", "fluid-chemicals", "a")
    move("acid-neutralisation", "fluid-chemicals", "b")
    move("steam-condensation", "fluid-chemicals", "c")
    move("organotins", "fluid-chemicals", "d")
    move("simple-nitric-acid", "fluid-chemicals", "e")
    move("nitric-acid", "fluid-chemicals", "f")
    move("sulfuric-acid", "fluid-chemicals", "g")
    move("lubricant", "fluid-chemicals", "h")

    move("chemical-waste-incineration", "fluid-chemicals", "i")
    move("chemical-waste-reprocessing", "fluid-chemicals", "j")
    move("chemical-waste-leaching", "fluid-chemicals", "k")
    move("depleted-acid-reprocessing", "fluid-chemicals", "l")
    move("depleted-acid-reprocessing-with-calcite", "fluid-chemicals", "m")

    move("stone", "stone", "a")
    move("sort-stone-zircon", "stone", "ba")
    move("sort-zircon-stone", "stone", "bb")
    move("stone-brick", "stone", "c")
    move("concrete", "stone", "d")
    move("concrete-from-molten-iron", "foundry-casting-items", "da")
    move("refined-concrete", "stone", "e")
    if not mods["dectorio"] then
        move("hazard-concrete", "stone", "db")
        move("refined-hazard-concrete", "stone", "ea")
    end
    move("silica", "stone", "f")
    move("silicon", "stone", "g")
    move("silicone", "stone", "h")

    move("basic-oil-processing", "oil-fractions", "a")
    move("advanced-oil-processing", "oil-fractions", "b")
    move("simple-coal-liquefaction", "oil-fractions", "c")
    move("coal-liquefaction", "oil-fractions", "d")
    move("heavy-oil-cracking", "oil-fractions", "e")
    move("light-oil-cracking", "oil-fractions", "f")
    move("solid-fuel-from-heavy-oil", "oil-fractions", "g")
    move("solid-fuel-from-light-oil", "oil-fractions", "h")
    move("solid-fuel-from-petroleum-gas", "oil-fractions", "i")
    move("solid-fuel", "oil-fractions", "j")

    if mods["BrimStuff"] then
        move("chemical-waste-incineration", "waste-processing", "a")
        move("chemical-waste-reprocessing", "waste-processing", "b")
        move("chemical-waste-leaching", "waste-processing", "c")
        move("depleted-acid-reprocessing", "waste-processing", "d")
        move("depleted-acid-reprocessing-with-calcite", "waste-processing", "e")
        move("coal-disposal", "waste-processing", "f")
        move("carbon-black-disposal", "waste-processing", "f")
        move("potassium-nitrate-disposal", "waste-processing", "g")
        move("solid-fuel-disposal", "waste-processing", "h")
        move("sulfur-disposal", "waste-processing", "i")
        move("toluene-disposal", "waste-processing", "j")
    end

    move("iron-gear-wheel", "rotary-components", "a")
    move("brass-balls", "rotary-components", "b")
    move("bearing", "rotary-components", "c")
    move("flywheel", "rotary-components", "d")
    move("spurving-bearing", "rotary-components", "e")
    move("cooling-fan", "rotary-components", "f")
    move("fast-gearbox", "rotary-components", "g")
    move("express-gearbox", "rotary-components", "h")
    move("engine-unit", "rotary-components", "i")
    move("electric-engine-unit", "rotary-components", "j")

    if count_items({"electric-motor", "drive-belt", "stepper-motor", "spark-plug"}) > 0 then
        move("electric-motor", "engine-components", "a")
        move("semiboloid-stator", "engine-components", "b")
        move("stepper-motor", "engine-components", "c")
        move("spark-plug", "engine-components", "d")
        move("drive-belt", "engine-components", "e")
        move("ambifacient-lunar-waneshaft", "engine-components", "f")
        move("engine-unit", "engine-components", "g")
        move("electric-engine-unit", "engine-components", "h")
    end

    if count_items({"malleable-logarithmic-casing", "hardened-hull", "lead-expansion-bolt", "crucible", mods["space-age"] and "no-item-at-all" or "low-density-structure"}) >= 2 then
        move("iron-stick", "structural-components", "a")
        move("lead-expansion-bolt", "structural-components", "b")
        move("malleable-logarithmic-casing", "structural-components", "c")
        move("loadbearing-lattice", "structural-components", "d")
        move("crucible", "structural-components", "e")
        move("hardened-hull", "structural-components", "f")
        if not mods["space-age"] then
            --pf-sa-compat makes a separate row for rocket components
            move("low-density-structure", "structural-components", "g")
        end
    end

    if count_items({"copper-cable", "neural-conductor", "tinned-cable", "optical-fiber", "gold-wire", "heavy-cable", "superconductor"}) >= 3 then
        move("copper-cable", "cable", "a")
        move("neural-conductor", "cable", "b")
        move("tinned-cable", "cable", "c")
        move("optical-fiber", "cable", "d")
        move("gold-wire", "cable", "e")
        move("heavy-cable", "cable", "f")
        move("superconductor", "cable", "g")

        if count_items({"battery", "solder", "electromagnetic-coil", "silicon-wafer", "supercapacitor"}) >= 3 then
            move("battery", "electronic-gubbins", "b-a")
            move("solder", "electronic-gubbins", "b-b")
            move("electromagnetic-coil", "electronic-gubbins", "b-c")                
            move("silicon-wafer", "electronic-gubbins", "b-d")                
            move("supercapacitor", "electronic-gubbins", "b-e")                
        else
            move("battery", "circuits", "a-a")
            move("solder", "circuits", "a-b")
            move("electromagnetic-coil", "circuits", "a-c")    
            move("silicon-wafer", "circuits", "a-d")    
            move("supercapacitor", "circuits", "a-e")    
        end
    else
        move("copper-cable", "electronic-gubbins", "a-a")
        move("neural-conductor", "electronic-gubbins", "a-b")
        move("tinned-cable", "electronic-gubbins", "a-c")
        move("optical-fiber", "electronic-gubbins", "a-d")
        move("gold-wire", "electronic-gubbins", "a-e")
        move("heavy-cable", "electronic-gubbins", "a-f")
        move("superconductor", "electronic-gubbins", "a-g")

        move("battery", "electronic-gubbins", "b-a")
        move("solder", "electronic-gubbins", "b-b")
        move("electromagnetic-coil", "electronic-gubbins", "b-c")
        move("silicon-wafer", "electronic-gubbins", "b-d")
        move("supercapacitor", "electronic-gubbins", "b-e")
    end

    move("integrated-circuit", "circuits", "b-a")
    move("electronic-circuit", "circuits", "b-b")
    move("advanced-circuit", "circuits", "b-c")
    move("processing-unit", "circuits", "b-d")
    move("quantum-processor", "circuits", "b-e")

    if count_items({"barrel", "pipe-flange", "airtight-seal", "high-pressure-valve", "fluid-regulator", "self-regulating-valve", "non-reversible-tremie-pipe", "hydrocoptic-marzelvane"}) >= 3 then
        move("barrel", "plumbing-components", "a")
        move("pipe-flange", "plumbing-components", "b")
        move("airtight-seal", "plumbing-components", "c")
        move("high-pressure-valve", "plumbing-components", "d")
        move("fluid-regulator", "plumbing-components", "e")
        move("self-regulating-valve", "plumbing-components", "f")
        move("non-reversible-tremie-pipe", "plumbing-components", "g")
        move("hydrocoptic-marzelvane", "plumbing-components", "h")
    end

    if count_items({"spring", "linkages", "motorized-arm", "complex-joint", "grabber", "differential-girdlespring", data.raw.item["iron-stick"].subgroup == "intermediate-product" and "iron-stick" or "no-item-at-all", mods["space-age"] and "no-item-at-all" or "gimbaled-rocket-engine"}) >= 3 then
        if data.raw.item["iron-stick"].subgroup == "intermediate-product" then
            move("iron-stick", "articulated-components", "a")
        end
        move("linkages", "articulated-components", "b")
        move("spring", "articulated-components", "c")
        move("motorized-arm", "articulated-components", "d")
        move("complex-joint", "articulated-components", "e")
        move("grabber", "articulated-components", "f")
        move("differential-girdlespring", "articulated-components", "g")
        if not mods["space-age"] then
            move("gimbaled-rocket-engine", "articulated-components", "h")
        end
    end

    if mods["bzcarbon"] then
        move("graphite", "bz-carbon-processing", "a")
        move("graphite-carbon-black", "bz-carbon-processing", "b")
        move("graphite-synthesis", "bz-carbon-processing", "c")
        move("carbon-black", "bz-carbon-processing", "d")
        move("fullerenes", "bz-carbon-processing", "e")
        move("polyacrylonitrile", "bz-carbon-processing", "f")
        if not mods["space-age"] then
            move("carbon-fiber", "bz-carbon-processing", "g")
        end
        move("nanotubes", "bz-carbon-processing", "h")
        move("graphene", "bz-carbon-processing", "i")
        move("diamond", "bz-carbon-processing", "j")
        move("diamond-processing", "bz-carbon-processing", "k")
        move("synthetic-diamond", "bz-carbon-processing", "l")
        move("graphitization", "bz-carbon-processing", "m")
    end

    move("solder-recycling", "alloy", "y")
    move("bronze-recycling", "alloy", "y")
    move("zircaloy-4-recycling", "alloy", "y")
    move("lead-lithium-eutectic-recycling", "alloy", "y")

    --MUST BE FIRST TO TAKE PRECEDENCE OVER SELF RECYCLING RECIPES!!!
    move_subgroup("alloy-separation", "resource-processing", "")

    if data.raw["item-subgroup"]["alloy-separation"] then
        move("brass-separation", "alloy-separation", "za")
        move("invar-separation", "alloy-separation", "zb")
    else
        move("brass-separation", "alloy", "za")
        move("invar-separation", "alloy", "zb")
    end

    if mods["space-age"] then
        move_subgroup("aquilo-processes", "resource-processing", "sa-d")

        move_item("carbon", "solid-chemicals", "a")
        move_item("ice", "solid-chemicals", "b")

        move("calcite", "foundry-misc", "a")
        move("malachite", "foundry-misc", "b")
        move("sphalerite", "foundry-misc", "c")
        move("tungsten-ore", "foundry-misc", "d")
        move("copper-ore-from-malachite", "foundry-misc", "z")

        move("stone-from-lava", "foundry-misc", "b")
        move("molten-iron-from-lava", "foundry-misc", "b")
        move("molten-copper-from-lava", "foundry-misc", "c")
        move("molten-nickel-from-lava", "foundry-misc", "c")
        move("molten-zinc-from-sphalerite", "foundry-misc", "d")
        move("molten-zinc-from-lava", "foundry-misc", "da")
        move("molten-lead-from-lava", "foundry-misc", "e")
        move("tin-sulfides", "foundry-misc", "f")
        move("tin-sulfide-processing", "foundry-misc", "fa")
        move("molten-gold-from-lava", "foundry-misc", "g")
        
        move_recipe("carbon", "foundry-misc", "m")
        move("tungsten-carbide", "foundry-misc", "n")
        move("tungsten-plate", "foundry-misc", "o")
        move("zirconium-tungstate", "foundry-misc", "p")

        move("molten-iron", "foundry-melting", "a")
        move("molten-copper", "foundry-melting", "b")
        move("molten-zinc", "foundry-melting", "c")
        move("molten-nickel", "foundry-melting", "d")
        move("molten-lead", "foundry-melting", "e")
        move("molten-tin", "foundry-melting", "f")
        move("molten-gold", "foundry-melting", "g")

        move("casting-iron", "foundry-casting-plates", "a")
        move("casting-steel", "foundry-casting-plates", "aa")
        move("casting-copper", "foundry-casting-plates", "b")
        move("casting-zinc", "foundry-casting-plates", "c")
        move("casting-brass", "foundry-casting-plates", "ca")
        move("casting-nickel", "foundry-casting-plates", "d")
        move("casting-invar", "foundry-casting-plates", "da")
        move("casting-lead", "foundry-casting-plates", "e")
        move("casting-tin", "foundry-casting-plates", "f")
        move("casting-bronze", "foundry-casting-plates", "fa")
        move("zirconium-in-foundry", "foundry-casting-plates", "g")
        move("casting-gold", "foundry-casting-plates", "h")
        move("titanium-in-foundry", "foundry-casting-plates", "i")

        move("casting-iron-gear-wheel", "foundry-casting-items", "a")
        move("casting-flywheel", "foundry-casting-items", "b")
        move("casting-iron-stick", "foundry-casting-items", "c")
        move("casting-copper-cable", "foundry-casting-items", "e")
        move("casting-gold-wire", "foundry-casting-items", "f")
        move("casting-solder", "foundry-casting-items", "g")
        move("casting-lead-expansion-bolt", "foundry-casting-items", "h")
        move("casting-pipe-flange", "foundry-casting-items", "i")
        move("casting-pipe", "foundry-casting-items", "j")
        move("casting-pipe-to-ground", "foundry-casting-items", "k")

        move("scrap", "holmium", "a")
        move("scrap-recycling", "holmium", "aa")
        move("holmium-ore", "holmium", "ab")
        move("weird-alien-gizmo-recycling", "holmium", "b")
        move("holmium-solution", "holmium", "c")
        move("spectroscopic-holmium-processing", "holmium", "ca")
        move("holmium-plate", "holmium", "d")
        move("electrolyte", "holmium", "e")
        move("activated-carbon", "holmium", "f")
        move("activated-carbon-black", "holmium", "g")

        move("tree-seed", "organic-raw-materials", "a")
        move("yumako-seed", "organic-raw-materials", "b")
        move("yumako", "organic-raw-materials", "ba")
        move("jellynut-seed", "organic-raw-materials", "c")
        move("jellynut", "organic-raw-materials", "ca")
        move("razorgrass-seed", "organic-raw-materials", "d")
        move("razorgrass", "organic-raw-materials", "da")
        move("spoilage", "organic-raw-materials", "e")
        move("yumako-mash", "organic-raw-materials", "f")
        move("yumako-processing", "organic-raw-materials", "fa")
        move("jelly", "organic-raw-materials", "g")
        move("jellynut-processing", "organic-raw-materials", "ga")
        move("razorgrass-dried", "organic-raw-materials", "h")
        move("razorgrass-ash", "organic-raw-materials", "ha")
        move("nutrients", "organic-raw-materials", "i")
        move("nutrients-from-yumako-mash", "organic-raw-materials", "j")
        move("nutrients-from-spoilage", "organic-raw-materials", "k")
        move("pentapod-egg", "organic-raw-materials", "l")
        move("aop-biomass", "organic-raw-materials", "m")

        move("bioflux", "biochemistry", "a")
        move("spectroscopic-bioflux-processing", "biochemistry", "aa")
        move("nutrients-from-bioflux", "biochemistry", "b")
        move("burnt-spoilage", "biochemistry", "c")
        move("biosulfur", "biochemistry", "d")
        move("bioplastic", "biochemistry", "e")
        move("biolubricant", "biochemistry", "f")
        move("silica-from-ash", "biochemistry", "g")
        move("chelated-lead", "biochemistry", "g")
        move("lead-dechelation", "biochemistry", "g")
        move("jellyskin-processing", "biochemistry", "g")
        move("tin-from-organotins", "biochemistry", "g")
        move("zirconia-from-egg", "biochemistry", "g")
        move("zircon-synthesis", "biochemistry", "ga")
        move("titanium-extraction", "biochemistry", "ga")
        move("ammonia-from-spoilage", "biochemistry", "g")
        move("carbon-fiber", "biochemistry", "h")
        move("spoilage-liquefaction", "biochemistry", "i")

        move("iron-bacteria", "bacteria", "a")
        move("copper-bacteria", "bacteria", "b")
        move("zinc-bacteria", "bacteria", "c")
        move("nickel-bacteria", "bacteria", "d")
        move("philosophers-hormone", "bacteria", "e")
        move("philosophers-hormone-from-iron-bacteria", "bacteria", "f")
        move("philosophers-hormone-from-copper-bacteria", "bacteria", "g")
        move("iron-bacteria-cultivation", "bacteria", "h")
        move("copper-bacteria-cultivation", "bacteria", "i")
        move("aop-hybrid-bacteria", "bacteria", "j")
        move("aop-hybrid-bacteria-cultivation", "bacteria", "k")

        move("biter-egg", "nauvis-agriculture", "b[nauvis-agriculture]-ca")
        move_subgroup("nauvis-agriculture", "resource-processing", "sa-c-e")
    end
end