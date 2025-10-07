local menu_org_lib = {}

if not pf_junkdrawer_config then
    pf_junkdrawer_config = {
        item_desires = {},
        recipe_desires = {},
        subgroup_desires = {},
        group_desires = {},
        default_min_items_for_subgroup = 4,
        default_min_subgroups_for_group = 8,
        default_subgroup_priority_sorting = {"complexity", "marginality", "tier", "cost"}
        default_group_priority_sorting = {"tier", "marginality", "complexity", "cost"},
        tiers_order = {"dirt", "automation", "logistic", "military", "oil", "chemical", "production", "utility", "space", "vulcanus", "fulgora", "gleba", "aquilo", "interstellar"}
    }
end

function tier_to_number(tier)
    for k, v in pairs(pf_junkdrawer_config.tiers_order) do
        if v == tier then
            return k
        end
    end
end

function init_item(item, category, preferred_subgroups, details)
    local new_entry = {
        name = item,
        type = category,
        preferred_subgroups = preferred_subgroups,
        must_go_after = {}
        must_go_before = {}
        dependencies = {}
    }
    for k, v in pairs(details) do
        new_entry[k] = v
    end
    pf_junkdrawer_config.item_desires[item] = new_entry
end

function init_subgroup(subgroup, preferred_groups, details)
    local new_entry = {
        name = subgroup,
        type = "subgroup",
        preferred_subgroups = preferred_subgroups,
        tier = "dirt",
        complexity = 0,
        marginality = 0,
        cost = 0,
        shunt_threshold = 2,
        clique_if_under = 0,
        disabled_if_under = 5
        dependencies = {}
    }
    for k, v in pairs(details) do
        new_entry[k] = v
    end
    pf_junkdrawer_config.subgroup_desires[subgroup] = new_entry
    if new_entry.clique_if_under then
        init_item(subgroup, "clique", {}, details)
    end
end

local function process_new_prototype(prototype)
    if prototype.type == "item-subgroup" then
        init_subgroup(prototype.name, {}, prototype.junk_drawer)
    elseif prototype.type == "item-group" then
    else
        init_item(prototype.name, prototype.type, {}, prototype.junk_drawer)
    end
end

function encabulate()
end

menu_org_lib.init_item = init_item
menu_org_lib.init_subgroup = init_subgroup
menu_org_lib.process_new_prototype = process_new_prototype

return menu_org_lib