local parts = {}
local misc_funcs = require "misc"

function parts.get_prototype(name, type)
  if type == nil then
    for k, v in pairs(defines.prototypes.item) do
      local p = parts.get_prototype(name, k)
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

return parts