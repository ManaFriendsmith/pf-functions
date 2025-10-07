data:extend({
    {
      type = "string-setting",
      name = "planetfall-difficulty",
      setting_type = "startup",
      default_value = "Moderate",
      allowed_values = {"Minimal", "Moderate", "Maximal"},
      order = "a"
    },
    {
      type = "bool-setting",
      name = "planetfall-reorganize-crafting-menu",
      setting_type = "startup",
      default_value = true,
      order = "b"
    }
  })