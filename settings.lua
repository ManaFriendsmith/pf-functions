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
      type = "string-setting",
      name = "planetfall-graphics-mode",
      setting_type = "startup",
      default_value = "Rendered",
      allowed_values = {"Vector", "Rendered"},
      order = "b"
    },
    {
      type = "bool-setting",
      name = "planetfall-reorganize-crafting-menu",
      setting_type = "startup",
      default_value = true,
      order = "c"
    }
  })