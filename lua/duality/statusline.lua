-- Duality statusline (no plugins needed). Same shape as lualine and Starship:
-- a rounded cap, then powerline arrows.
-- The reverse of the Starship prompt: it fades from light into shadow.
--   mode → git (Ember) → file (Penance) ··· diagnostics (Umbral) → filetype (Twilight robe) → clock (Dusk)
-- Usage: require("duality.statusline").setup()
local M = {}

local c = require("duality.palette")

M.config = {
  -- Nerd Font glyphs, written as escapes so they survive copy and paste.
  separator_left = "\u{e0b0}", -- powerline arrows, as in Starship; "" for flat blocks
  separator_right = "\u{e0b2}",
  cap_left = "\u{e0b6}", -- rounded ends; "" to turn off
  cap_right = "\u{e0b4}",
  clock = true,
  clock_format = "%H:%M",
}

local modes = {
  n = { "NORMAL", "DualityModeNormal", c.mind_flay },
  no = { "O-PEND", "DualityModeNormal", c.mind_flay },
  i = { "INSERT", "DualityModeInsert", c.holy_nova },
  ic = { "INSERT", "DualityModeInsert", c.holy_nova },
  v = { "VISUAL", "DualityModeVisual", c.penance },
  V = { "V-LINE", "DualityModeVisual", c.penance },
  ["\22"] = { "V-BLOCK", "DualityModeVisual", c.penance },
  s = { "SELECT", "DualityModeVisual", c.penance },
  S = { "S-LINE", "DualityModeVisual", c.penance },
  R = { "REPLACE", "DualityModeReplace", c.holy_fire },
  c = { "COMMAND", "DualityModeCommand", c.halo },
  t = { "TERMINAL", "DualityModeTerminal", c.old_gods_eye },
}

-- Separator groups are made on demand: fg = colour we leave, bg = colour we enter.
local made = {}
local function sep(from, to)
  local name = "DualitySep" .. from:sub(2) .. to:sub(2)
  if not made[name] then
    vim.api.nvim_set_hl(0, name, { fg = from, bg = to })
    made[name] = true
  end
  return "%#" .. name .. "#"
end

local function mode_info()
  local m = vim.api.nvim_get_mode().mode
  return modes[m] or modes[m:sub(1, 1)] or modes.n
end

local function git_head()
  local head = vim.b.gitsigns_head or vim.g.gitsigns_head
  if (not head or head == "") and vim.b.minigit_summary then
    head = vim.b.minigit_summary.head_name
  end
  return head and head ~= "" and head or nil
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN] or 0
  local parts = {}
  if e > 0 then
    table.insert(parts, "%#DualityDiagError# \u{f057} " .. e)
  end
  if w > 0 then
    table.insert(parts, "%#DualityDiagWarn# \u{f071} " .. w)
  end
  return #parts > 0 and table.concat(parts, " ") or nil
end

function M.render()
  local L, R = M.config.separator_left, M.config.separator_right
  local label, mode_hl, mode_bg = unpack(mode_info())
  local out = {}

  -- Left: the lit end.
  if M.config.cap_left ~= "" then
    table.insert(out, sep(mode_bg, c.abyss) .. M.config.cap_left)
  end
  table.insert(out, "%#" .. mode_hl .. "# " .. label .. " ")
  local prev = mode_bg

  local head = git_head()
  if head then
    head = head:gsub("%%", "%%%%")
    table.insert(out, sep(prev, c.ember) .. L .. "%#DualityGit# \u{e0a0} " .. head .. " ")
    prev = c.ember
  end

  local name = vim.fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end
  name = name:gsub("%%", "%%%%")
  local flags = (vim.bo.modified and " ●" or "") .. ((vim.bo.readonly or not vim.bo.modifiable) and " \u{f023}" or "")
  table.insert(out, sep(prev, c.penance) .. L .. "%#DualityFile# " .. name .. flags .. " ")
  table.insert(out, sep(c.penance, c.void) .. L .. "%#DualityFill#")

  -- Middle: neutral ground.
  table.insert(out, "%=")

  -- Right: falling into shadow.
  prev = c.void
  local d = diagnostics()
  if d then
    table.insert(out, sep(c.umbral, prev) .. R .. "%#DualityDiag#" .. d .. " ")
    prev = c.umbral
  end

  local ft = vim.bo.filetype
  if ft ~= "" then
    table.insert(out, sep(c.twilight_robe, prev) .. R .. "%#DualityFiletype# " .. ft .. " ")
    prev = c.twilight_robe
  end

  table.insert(out, sep(c.dusk, prev) .. R .. "%#DualityClock# %l:%c ")
  if M.config.clock then
    table.insert(out, "· " .. os.date(M.config.clock_format) .. " ")
  end
  if M.config.cap_right ~= "" then
    table.insert(out, sep(c.dusk, c.abyss) .. M.config.cap_right)
  end

  return table.concat(out)
end

function M.render_inactive()
  return "%#StatusLineNC# %f %m%=%l:%c "
end

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})

  -- Separator groups are cleared by :colorscheme; rebuild on demand.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("DualityStatusline", { clear = true }),
    callback = function()
      made = {}
    end,
  })

  vim.o.statusline = "%!v:lua.require'duality.statusline'.statusline()"

  if M.config.clock and not M._timer then
    M._timer = vim.uv.new_timer()
    M._timer:start(30000, 30000, vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end))
  end
end

function M.statusline()
  if vim.g.statusline_winid == vim.api.nvim_get_current_win() then
    return M.render()
  end
  return M.render_inactive()
end

return M
