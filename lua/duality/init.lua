local M = {}

M.defaults = {
  transparent = false, -- leave the background to the terminal (Kitty is already Abyss)
  dim_inactive = true, -- inactive windows fall into shadow (Void bg, Ashen robe text)
  italic_comments = true,
  italic_params = true,
  bright_comments = false, -- raise comments from Ashen robe (3.3:1) to Veil-ish if they're hard to read
  terminal_colors = true,
  on_highlights = nil, -- function(hl, c) end; mutate hl to override groups
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "duality"

  local c = require("duality.palette")
  local hl = require("duality.groups").get(c, M.options)

  if M.options.on_highlights then
    M.options.on_highlights(hl, c)
  end

  for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if M.options.terminal_colors then
    -- Normal colours lean to shadow, bright colours lean to light.
    local ansi = {
      c.dusk, c.sw_pain, c.old_gods_eye, c.holy_nova,
      c.shadowfiend, c.void_bolt, c.abyssal_tide, c.veil,
      c.ashen_robe, c.holy_fire, c.renew, c.halo,
      c.pw_shield, c.penitent, c.naaru, c.sanctuary,
    }
    for i, col in ipairs(ansi) do
      vim.g["terminal_color_" .. (i - 1)] = col
    end
  end
end

return M
