-- Duality lualine theme: fades from light into shadow (a → b → c).
-- lualine mirrors a/b/c onto z/y/x; see the README for the full six-segment fade.
local c = require("duality.palette")

local function mode(bg, fg)
  return {
    a = { fg = fg or c.abyss, bg = bg, gui = "bold" },
    b = { fg = c.abyss, bg = c.ember, gui = "bold" }, -- git
    c = { fg = c.veil, bg = c.void },
  }
end

return {
  normal = mode(c.mind_flay, c.priest_white), -- shadow
  insert = mode(c.holy_nova), -- light
  visual = mode(c.penance), -- twilight
  replace = mode(c.holy_fire),
  command = mode(c.halo),
  terminal = mode(c.old_gods_eye),
  inactive = {
    a = { fg = c.ashen_robe, bg = c.void },
    b = { fg = c.ashen_robe, bg = c.void },
    c = { fg = c.ashen_robe, bg = c.void },
  },
}
