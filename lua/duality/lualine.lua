-- Duality's default lualine layout: the reverse of the Starship prompt.
-- Rounded cap, then powerline arrows, fading from light into shadow:
--   mode → Ember (git) → Penance (file) ··· Umbral (diagnostics) → Twilight robe (filetype) → Dusk (position, clock)
--
-- Usage in your lualine spec:
--   opts = function() return require("duality.lualine").opts() end
-- Override anything by passing a table:
--   require("duality.lualine").opts({ options = { globalstatus = false }, sections = { lualine_c = { "filename" } } })
local M = {}

M.glyphs = {
  cap_left = "\u{e0b6}", -- rounded, like the start of the prompt
  cap_right = "\u{e0b4}",
  arrow_left = "\u{e0b0}", -- powerline arrows between segments
  arrow_right = "\u{e0b2}",
  branch = "\u{e0a0}",
}

function M.opts(overrides)
  local c = require("duality.palette")
  local g = M.glyphs
  overrides = overrides or {}

  local opts = {
    options = {
      theme = "duality",
      component_separators = "",
      section_separators = { left = g.arrow_left, right = g.arrow_right },
      globalstatus = true,
    },
    sections = {
      lualine_a = { { "mode", separator = { left = g.cap_left }, right_padding = 2 } },
      lualine_b = { { "branch", icon = g.branch, color = { fg = c.abyss, bg = c.ember, gui = "bold" } } },
      lualine_c = { { "filename", color = { fg = c.abyss, bg = c.penance } } },
      lualine_x = {
        {
          "diagnostics",
          color = { bg = c.umbral },
          diagnostics_color = {
            error = { fg = c.holy_fire, bg = c.umbral },
            warn = { fg = c.ember, bg = c.umbral },
            info = { fg = c.pw_shield, bg = c.umbral },
            hint = { fg = c.naaru, bg = c.umbral },
          },
        },
      },
      lualine_y = { { "filetype", color = { fg = c.halo, bg = c.twilight_robe } } },
      lualine_z = {
        { "location", color = { fg = c.veil, bg = c.dusk } },
        {
          function()
            return os.date("%H:%M")
          end,
          color = { fg = c.veil, bg = c.dusk },
          separator = { right = g.cap_right },
        },
      },
    },
    inactive_sections = {
      lualine_c = { "filename" },
      lualine_x = { "location" },
    },
  }

  -- options merge deeply; each section you pass replaces that whole section.
  opts.options = vim.tbl_deep_extend("force", opts.options, overrides.options or {})
  for _, key in ipairs({ "sections", "inactive_sections" }) do
    for name, section in pairs(overrides[key] or {}) do
      opts[key][name] = section
    end
  end
  for k, v in pairs(overrides) do
    if k ~= "options" and k ~= "sections" and k ~= "inactive_sections" then
      opts[k] = v
    end
  end

  return opts
end

return M
