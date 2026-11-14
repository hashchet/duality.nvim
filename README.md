# duality.nvim

Neovim colourscheme for **Duality**: Shadow and Light on neutral ground.
Shadow is structure (keywords, types, operators), Light is meaning (functions, calls, strings), and twilight carries the in-between (constants, numbers, parameters, decorators).

Covers: core UI, legacy syntax, Treesitter, LSP semantic tokens, diagnostics, terminal colours, and gitsigns, mini.diff, telescope, fzf-lua, snacks, nvim-cmp, blink.cmp, neo-tree, nvim-tree, oil, mini.files, which-key, indent-blankline, bufferline, noice, notify, flash, leap, lazy, mason, treesitter-context, rainbow-delimiters and trouble. Includes a lualine theme and a plugin-free statusline.

Needs Neovim 0.10+ (0.11 recommended).

## Install

### lazy.nvim

Replace `<your-github-user>` with the account you pushed the repo to:

```lua
{
  "<your-github-user>/duality.nvim",
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

While developing, point lazy at your local clone instead of GitHub:

```lua
{ dir = "~/theme/Duality/duality.nvim", name = "duality", lazy = false, priority = 1000, ... }
```

### Without a plugin manager

```lua
vim.opt.rtp:prepend(vim.fn.expand("~/theme/Duality/duality.nvim"))
vim.cmd.colorscheme("duality")
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

The statusline is the reverse of the Starship prompt, fading from light into shadow, with the same shape: a rounded cap, then powerline arrows.
mode → Ember (git) → Penance (file) ··· Umbral (diagnostics) → Twilight robe (filetype) → Dusk (position, clock), on Void.
The mode block is Mind flay in Normal, Holy nova in Insert, Penance in Visual.

Both options below need a Nerd Font. Use one or the other, not both.

### lualine

The theme ships the whole layout, so your lualine spec only needs one line:

```lua
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    return require("duality.lualine").opts()
  end,
}
```

To change something, pass a table. `options` are merged; each section you pass replaces that section:

```lua
opts = function()
  return require("duality.lualine").opts({
    options = { globalstatus = false },
    sections = { lualine_c = { { "filename", path = 1 } } },
  })
end,
```

If you only want the colours and your own layout, use `theme = "duality"` in your lualine options instead.

### Built-in (no plugins)

```lua
require("duality.statusline").setup({
  -- separator_left = "", separator_right = "",  -- flat blocks instead of arrows
  -- cap_left = "", cap_right = "",              -- square ends instead of rounded
  -- clock = false,
})
```

It reads the branch from gitsigns or mini.git. Works well with `vim.o.laststatus = 3`.

## Files

```
colors/duality.lua              :colorscheme entry point
lua/duality/init.lua            setup() and load()
lua/duality/palette.lua         all 29 colours
lua/duality/groups.lua          every highlight group
lua/duality/statusline.lua      plugin-free statusline
lua/duality/lualine.lua         default lualine layout
lua/lualine/themes/duality.lua  lualine theme
```
