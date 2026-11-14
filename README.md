# duality.nvim

Neovim colourscheme for **Duality**: Shadow and Light on neutral ground.
Shadow is structure (keywords, types, operators), Light is meaning (functions, calls, strings), and twilight carries the in-between (constants, numbers, parameters, decorators).

Covers: core UI, legacy syntax, Treesitter, LSP semantic tokens, diagnostics, terminal colours, and gitsigns, mini.diff, telescope, fzf-lua, snacks, nvim-cmp, blink.cmp, neo-tree, nvim-tree, oil, mini.files, which-key, indent-blankline, bufferline, noice, notify, flash, leap, lazy, mason, treesitter-context, rainbow-delimiters and trouble. Includes a lualine theme and a plugin-free statusline.

Needs Neovim 0.10+ (0.11 recommended).

## Install

### lazy.nvim

```lua
{
  "hashchet/duality.nvim",
  name = "duality",
  lazy = false,
  priority = 1000,
  opts = {
    -- transparent = true,      -- let Kitty's Abyss show through
    -- dim_inactive = false,    -- keep inactive splits on Abyss
    -- bright_comments = true,  -- if Ashen robe comments are too faint
  },
  config = function(_, opts)
    require("duality").setup(opts)
    vim.cmd.colorscheme("duality")
    -- require("duality.statusline").setup() -- plugin-free statusline (skip if using lualine)
  end,
}
```


## Options

| Option | Default | What it does |
|---|---|---|
| `transparent` | `false` | No background on Normal, floats or sign column |
| `dim_inactive` | `true` | Inactive windows fall into shadow: Void background, Ashen robe text |
| `italic_comments` | `true` | Italic comments |
| `italic_params` | `true` | Italic parameters |
| `bright_comments` | `false` | Lift comments halfway to Veil (Ashen robe is 3.3:1 on Abyss, 2.8:1 on the cursor line) |
| `terminal_colors` | `true` | Sets `:terminal` ANSI 16 to match Kitty |
| `on_highlights` | `nil` | `function(hl, c)`: change any group before it's applied |


```lua
require("duality").setup({
  on_highlights = function(hl, c)
    hl.CursorLine = { bg = c.void }
    hl["@variable.member"] = { fg = c.priest_white }
  end,
})
```

The palette is available to your own config with `require("duality.palette")`.

## Statusline

The statusline is the reverse of the Starship prompt, fading from light into shadow:
mode → Ember (git) → Penance (file) ··· Umbral (diagnostics) → Twilight robe (filetype) → Dusk (position, clock), on Void.
The mode block is Mind flay in Normal, Holy nova in Insert, Penance in Visual.

### Built-in (no plugins)

```lua
require("duality.statusline").setup({
  -- separator_left = "", separator_right = "",  -- flat blocks
  -- clock = false,
})
```

It reads the branch from gitsigns or mini.git. Works well with `vim.o.laststatus = 3`.

### lualine

`theme = "duality"` gives the mode colours. For the full six-segment fade, colour the components directly:

```lua
local c = require("duality.palette")
require("lualine").setup({
  options = {
    theme = "duality",
    component_separators = "",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "branch", icon = "", color = { fg = c.abyss, bg = c.ember, gui = "bold" } } },
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
      { function() return os.date("%H:%M") end, color = { fg = c.veil, bg = c.dusk } },
    },
  },
})
```

## Files

```
colors/duality.lua              :colorscheme entry point
lua/duality/init.lua            setup() and load()
lua/duality/palette.lua         all 29 colours
lua/duality/groups.lua          every highlight group
lua/duality/statusline.lua      plugin-free statusline
lua/lualine/themes/duality.lua  lualine theme
```
