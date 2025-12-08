local misc_funcs = {}

local function get_difficulty()
    local d = settings.startup["planetfall-difficulty"].value
    if d == "Minimal" then return 1 end
    if d == "Moderate" then return 2 end
    if d == "Maximal" then return 3 end
    log("Some other mod broke the difficulty selection. Please report this.")
    return 3
end

--Is this nothing? Yes. Can I never remember the exact syntax? Yes.
local function GetSetting(setting_name)
    if settings.startup[setting_name] then
        return settings.startup[setting_name].value
    end
    return nil
end

local function GetPrototype(name, type)
  if type == nil then
    for k, v in pairs(defines.prototypes.item) do
      local p = GetPrototype(name, k)
      if p then
        return p
      end
    end
    return nil
  end
  if data.raw[type] then
    return data.raw[type][name]
  end
  return nil
end

local function VariableGraphicsPath(prefix, postfix)
  if settings.startup["planetfall-graphics-mode"].value == "Vector" then
    return prefix .. "/vector/" .. postfix
  else
    return prefix .. "/render/" .. postfix
  end
end

local pf_reverse_load_order = {"LasingAroundMk2", "BrimStuffMk2", "ThemTharHillsMk2", "IfNickelMk2", "BrassTacksMk2", "pf-sa-compat", "pf-functions"}
for k, v in pairs(pf_reverse_load_order) do
  if mods[v] then
    misc_funcs.last_pf_mod = v
    break
  end
end

misc_funcs.difficulty = get_difficulty()
misc_funcs.GetSetting = GetSetting
misc_funcs.GetPrototype = GetPrototype
misc_funcs.VariableGraphicsPath = VariableGraphicsPath
misc_funcs.AddLaserMillData = AddLaserMillData

if mods["any-planet-start"] then
    misc_funcs.starting_planet =  settings.startup["aps-planet"].value
else
    misc_funcs.starting_planet = "nauvis"
end

return misc_funcs
