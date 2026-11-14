-- Duality palette: Shadow and Light, on neutral ground.
-- Every shadow colour has a light twin; twilight is where they meet.
local M = {
  -- Ground (neutral surfaces)
  abyss = "#0D0C11", -- main background
  void = "#15141A", -- panels, inactive splits, statusline background
  dusk = "#1E1C25", -- raised surfaces, cursor line
  shroud = "#2D2A35", -- borders, dividers

  -- Shadow
  twilight_robe = "#3A2356", -- selection
  umbral = "#5B2E8C", -- deep accent
  mind_flay = "#8A4FD1", -- operators, Normal mode
  void_bolt = "#B57BFF", -- keywords
  shadowfiend = "#7B6CF0", -- shadow blue
  shadowfiend_light = "#8F82F7", -- types
  sw_pain = "#C2447A", -- shadow red
  old_gods_eye = "#4FBF8F", -- shadow green
  abyssal_tide = "#5FA8C9", -- shadow cyan

  -- Twilight
  insanity = "#D63FE8", -- decorators, "shadow takes over"
  penance = "#B5729E", -- constants, Visual mode
  penitent = "#E3A0C8", -- parameters
  ember = "#E0965A", -- numbers, warnings
  ashen_robe = "#6E5C88", -- comments, dim text
  veil = "#C9BEDB", -- secondary text

  -- Light
  gilded = "#A87B22", -- deep gold
  holy_nova = "#D9A93F", -- function definitions, Insert mode
  halo = "#F2D58A", -- cursor, function calls, current line number
  holy_fire = "#E8796A", -- errors
  renew = "#B5D46A", -- strings, git added
  pw_shield = "#A9D8FF", -- light blue, info
  naaru = "#9FE6E0", -- builtins, hints
  radiant_dawn = "#FFF1C9", -- selection text
  priest_white = "#EDE6F5", -- default foreground
  sanctuary = "#FAF6EE", -- brightest white

  none = "NONE",
}

return M
