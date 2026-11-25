local M = {}

-- Mix fg into bg by `alpha` (0..1). Used for tinted backgrounds (diffs, diagnostics).
local function blend(fg, bg, alpha)
  local function rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
  end
  local fr, fg_, fb = rgb(fg)
  local br, bg_, bb = rgb(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02X%02X%02X", mix(fr, br), mix(fg_, bg_), mix(fb, bb))
end
M.blend = blend

function M.get(c, o)
  local bg = o.transparent and c.none or c.abyss
  local bg_nc = o.transparent and c.none or (o.dim_inactive and c.void or c.abyss)
  local fg_nc = o.dim_inactive and c.ashen_robe or c.priest_white
  local float_bg = o.transparent and c.none or c.void
  local comment = o.bright_comments and blend(c.veil, c.ashen_robe, 0.5) or c.ashen_robe

  local hl = {}

  ---------------------------------------------------------------------------
  -- Editor UI
  ---------------------------------------------------------------------------
  hl.Normal = { fg = c.priest_white, bg = bg }
  hl.NormalNC = { fg = fg_nc, bg = bg_nc }
  hl.NormalFloat = { fg = c.priest_white, bg = float_bg }
  hl.FloatBorder = { fg = c.shroud, bg = float_bg }
  hl.FloatTitle = { fg = c.holy_nova, bg = float_bg, bold = true }
  hl.FloatFooter = { fg = c.ashen_robe, bg = float_bg }
  hl.WinSeparator = { fg = c.shroud, bg = c.none }
  hl.VertSplit = { link = "WinSeparator" }
  hl.EndOfBuffer = { fg = c.abyss }
  hl.NonText = { fg = c.shroud }
  hl.Whitespace = { fg = c.shroud }
  hl.SpecialKey = { fg = c.shroud }
  hl.Conceal = { fg = c.ashen_robe }

  -- Light wins your attention: cursor and current line number are lit.
  hl.Cursor = { fg = c.abyss, bg = c.halo }
  hl.lCursor = { link = "Cursor" }
  hl.CursorIM = { link = "Cursor" }
  hl.TermCursor = { link = "Cursor" }
  hl.CursorLine = { bg = c.dusk }
  hl.CursorColumn = { bg = c.dusk }
  hl.ColorColumn = { bg = c.void }
  hl.LineNr = { fg = c.ashen_robe }
  hl.LineNrAbove = { link = "LineNr" }
  hl.LineNrBelow = { link = "LineNr" }
  hl.CursorLineNr = { fg = c.halo, bold = true }
  hl.SignColumn = { fg = c.ashen_robe, bg = c.none }
  hl.CursorLineSign = { link = "SignColumn" }
  hl.FoldColumn = { fg = c.shroud, bg = c.none }
  hl.CursorLineFold = { fg = c.ashen_robe }
  hl.Folded = { fg = c.veil, bg = c.void, italic = true }

  -- Shadow claims what you select.
  hl.Visual = { fg = c.radiant_dawn, bg = c.twilight_robe }
  hl.VisualNOS = { link = "Visual" }

  hl.Search = { fg = c.abyss, bg = c.gilded }
  hl.CurSearch = { fg = c.abyss, bg = c.halo, bold = true }
  hl.IncSearch = { link = "CurSearch" }
  hl.Substitute = { fg = c.abyss, bg = c.penance }
  hl.MatchParen = { fg = c.halo, bg = c.shroud, bold = true }
  hl.QuickFixLine = { bg = c.dusk, bold = true }

  hl.Pmenu = { fg = c.veil, bg = c.void }
  hl.PmenuSel = { fg = c.radiant_dawn, bg = c.twilight_robe, bold = true }
  hl.PmenuKind = { fg = c.shadowfiend_light, bg = c.void }
  hl.PmenuKindSel = { fg = c.shadowfiend_light, bg = c.twilight_robe }
  hl.PmenuExtra = { fg = c.ashen_robe, bg = c.void }
  hl.PmenuExtraSel = { fg = c.veil, bg = c.twilight_robe }
  hl.PmenuSbar = { bg = c.dusk }
  hl.PmenuThumb = { bg = c.shroud }
  hl.PmenuMatch = { fg = c.holy_nova, bold = true }
  hl.PmenuMatchSel = { fg = c.halo, bold = true }
  hl.WildMenu = { link = "PmenuSel" }

  hl.StatusLine = { fg = c.veil, bg = c.void }
  hl.StatusLineNC = { fg = c.ashen_robe, bg = c.void }
  hl.StatusLineTerm = { link = "StatusLine" }
  hl.StatusLineTermNC = { link = "StatusLineNC" }
  hl.WinBar = { fg = c.veil, bg = c.none, bold = true }
  hl.WinBarNC = { fg = c.ashen_robe, bg = c.none }

  -- Active tab: Halo text, Holy nova underline.
  hl.TabLine = { fg = c.ashen_robe, bg = c.void }
  hl.TabLineFill = { bg = c.void }
  hl.TabLineSel = { fg = c.halo, bg = c.abyss, bold = true, underline = true, sp = c.holy_nova }

  hl.Title = { fg = c.holy_nova, bold = true }
  hl.Directory = { fg = c.void_bolt, bold = true } -- structure, like eza
  hl.ModeMsg = { fg = c.holy_nova, bold = true }
  hl.MsgArea = { fg = c.priest_white }
  hl.MoreMsg = { fg = c.old_gods_eye }
  hl.Question = { fg = c.halo }
  hl.ErrorMsg = { fg = c.holy_fire, bold = true }
  hl.WarningMsg = { fg = c.ember, bold = true }
  hl.OkMsg = { fg = c.renew }

  hl.SpellBad = { undercurl = true, sp = c.holy_fire }
  hl.SpellCap = { undercurl = true, sp = c.ember }
  hl.SpellLocal = { undercurl = true, sp = c.naaru }
  hl.SpellRare = { undercurl = true, sp = c.penitent }

  -- Diffs: tinted grounds so the code colours still read on top.
  hl.DiffAdd = { bg = blend(c.renew, c.abyss, 0.14) }
  hl.DiffChange = { bg = blend(c.holy_nova, c.abyss, 0.10) }
  hl.DiffDelete = { fg = blend(c.holy_fire, c.abyss, 0.6), bg = blend(c.holy_fire, c.abyss, 0.12) }
  hl.DiffText = { bg = blend(c.holy_nova, c.abyss, 0.28) }
  hl.Added = { fg = c.renew }
  hl.Changed = { fg = c.holy_nova }
  hl.Removed = { fg = c.holy_fire }
  hl.diffAdded = { link = "Added" }
  hl.diffChanged = { link = "Changed" }
  hl.diffRemoved = { link = "Removed" }
  hl.diffLine = { fg = c.void_bolt }
  hl.diffFile = { fg = c.holy_nova, bold = true }

  ---------------------------------------------------------------------------
  -- Syntax: shadow is structure, light is meaning
  ---------------------------------------------------------------------------
  hl.Comment = { fg = comment, italic = o.italic_comments }
  hl.SpecialComment = { fg = c.veil, italic = o.italic_comments }

  hl.Constant = { fg = c.penance }
  hl.String = { fg = c.renew }
  hl.Character = { fg = c.renew }
  hl.Number = { fg = c.ember }
  hl.Float = { link = "Number" }
  hl.Boolean = { fg = c.penance, bold = true }

  hl.Identifier = { fg = c.priest_white }
  hl.Function = { fg = c.holy_nova }

  hl.Statement = { fg = c.void_bolt }
  hl.Keyword = { fg = c.void_bolt }
  hl.Conditional = { link = "Keyword" }
  hl.Repeat = { link = "Keyword" }
  hl.Label = { fg = c.void_bolt }
  hl.Exception = { fg = c.void_bolt }
  hl.Operator = { fg = c.mind_flay }

  hl.PreProc = { fg = c.void_bolt }
  hl.Include = { fg = c.void_bolt }
  hl.Define = { fg = c.void_bolt }
  hl.Macro = { fg = c.insanity }
  hl.PreCondit = { fg = c.void_bolt }

  hl.Type = { fg = c.shadowfiend_light }
  hl.StorageClass = { fg = c.void_bolt }
  hl.Structure = { fg = c.shadowfiend_light }
  hl.Typedef = { fg = c.shadowfiend_light }

  hl.Special = { fg = c.naaru }
  hl.SpecialChar = { fg = c.naaru }
  hl.Tag = { fg = c.void_bolt }
  hl.Delimiter = { fg = c.veil }
  hl.Debug = { fg = c.ember }

  hl.Underlined = { underline = true }
  hl.Bold = { bold = true }
  hl.Italic = { italic = true }
  hl.Ignore = { fg = c.shroud }
  hl.Error = { fg = c.holy_fire }
  hl.Todo = { fg = c.abyss, bg = c.holy_nova, bold = true }

  ---------------------------------------------------------------------------
  -- Treesitter
  ---------------------------------------------------------------------------
  local ts = {
    ["@variable"] = { fg = c.priest_white },
    ["@variable.builtin"] = { fg = c.naaru, italic = true },
    ["@variable.parameter"] = { fg = c.penitent, italic = o.italic_params },
    ["@variable.parameter.builtin"] = { fg = c.penitent, italic = o.italic_params },
    ["@variable.member"] = { fg = c.veil },

    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = c.naaru },
    ["@constant.macro"] = { fg = c.insanity },

    ["@module"] = { fg = c.shadowfiend_light },
    ["@module.builtin"] = { fg = c.naaru },
    ["@label"] = { fg = c.void_bolt },

    ["@string"] = { link = "String" },
    ["@string.documentation"] = { fg = c.renew, italic = true },
    ["@string.regexp"] = { fg = c.naaru },
    ["@string.escape"] = { fg = c.naaru, bold = true },
    ["@string.special"] = { fg = c.naaru },
    ["@string.special.symbol"] = { fg = c.penance },
    ["@string.special.url"] = { fg = c.naaru, underline = true },
    ["@string.special.path"] = { fg = c.abyssal_tide },

    ["@character"] = { link = "Character" },
    ["@character.special"] = { fg = c.naaru },
    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Number" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.shadowfiend_light, italic = true },
    ["@type.definition"] = { fg = c.shadowfiend_light, bold = true },
    ["@attribute"] = { fg = c.insanity },
    ["@attribute.builtin"] = { fg = c.insanity },
    ["@property"] = { fg = c.veil },

    -- Light: what the code does. Definitions are Holy nova, calls are Halo.
    ["@function"] = { fg = c.holy_nova },
    ["@function.builtin"] = { fg = c.naaru },
    ["@function.call"] = { fg = c.halo },
    ["@function.macro"] = { fg = c.insanity },
    ["@function.method"] = { fg = c.holy_nova },
    ["@function.method.call"] = { fg = c.halo },
    ["@constructor"] = { fg = c.shadowfiend_light },
    ["@operator"] = { link = "Operator" },

    -- Shadow: the skeleton.
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.coroutine"] = { fg = c.void_bolt, italic = true },
    ["@keyword.function"] = { fg = c.void_bolt },
    ["@keyword.operator"] = { fg = c.mind_flay, bold = true },
    ["@keyword.import"] = { fg = c.void_bolt },
    ["@keyword.type"] = { fg = c.void_bolt },
    ["@keyword.modifier"] = { fg = c.void_bolt, italic = true },
    ["@keyword.repeat"] = { link = "Keyword" },
    ["@keyword.return"] = { fg = c.void_bolt, bold = true },
    ["@keyword.debug"] = { fg = c.ember },
    ["@keyword.exception"] = { fg = c.void_bolt },
    ["@keyword.conditional"] = { link = "Keyword" },
    ["@keyword.conditional.ternary"] = { fg = c.mind_flay },
    ["@keyword.directive"] = { fg = c.insanity },
    ["@keyword.directive.define"] = { fg = c.insanity },

    ["@punctuation.delimiter"] = { fg = c.veil },
    ["@punctuation.bracket"] = { fg = c.veil },
    ["@punctuation.special"] = { fg = c.mind_flay },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "SpecialComment" },
    ["@comment.error"] = { fg = c.abyss, bg = c.holy_fire, bold = true },
    ["@comment.warning"] = { fg = c.abyss, bg = c.ember, bold = true },
    ["@comment.todo"] = { link = "Todo" },
    ["@comment.note"] = { fg = c.abyss, bg = c.naaru, bold = true },

    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.holy_nova, bold = true },
    ["@markup.heading.1"] = { fg = c.halo, bold = true },
    ["@markup.heading.2"] = { fg = c.holy_nova, bold = true },
    ["@markup.heading.3"] = { fg = c.ember, bold = true },
    ["@markup.heading.4"] = { fg = c.penance, bold = true },
    ["@markup.heading.5"] = { fg = c.void_bolt, bold = true },
    ["@markup.heading.6"] = { fg = c.mind_flay, bold = true },
    ["@markup.quote"] = { fg = c.veil, italic = true },
    ["@markup.math"] = { fg = c.naaru },
    ["@markup.link"] = { fg = c.void_bolt },
    ["@markup.link.label"] = { fg = c.holy_nova },
    ["@markup.link.url"] = { fg = c.naaru, underline = true },
    ["@markup.raw"] = { fg = c.renew },
    ["@markup.raw.block"] = { fg = c.veil },
    ["@markup.list"] = { fg = c.mind_flay },
    ["@markup.list.checked"] = { fg = c.renew },
    ["@markup.list.unchecked"] = { fg = c.ashen_robe },

    ["@diff.plus"] = { link = "Added" },
    ["@diff.minus"] = { link = "Removed" },
    ["@diff.delta"] = { link = "Changed" },

    ["@tag"] = { fg = c.void_bolt },
    ["@tag.builtin"] = { fg = c.void_bolt },
    ["@tag.attribute"] = { fg = c.penitent, italic = true },
    ["@tag.delimiter"] = { fg = c.ashen_robe },
  }
  for k, v in pairs(ts) do
    hl[k] = v
  end

  ---------------------------------------------------------------------------
  -- LSP semantic tokens (mostly defer to Treesitter so the two agree)
  ---------------------------------------------------------------------------
  local sem = {
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = {}, -- let Treesitter handle comments
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.interface"] = { fg = c.shadowfiend_light, italic = true },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { fg = c.shadowfiend_light, italic = true },
    ["@lsp.type.variable"] = {}, -- Treesitter is more precise here
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.readonly"] = { link = "@constant" },
    ["@lsp.typemod.variable.global"] = { fg = c.penance },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }
  for k, v in pairs(sem) do
    hl[k] = v
  end

  hl.LspReferenceText = { bg = c.shroud }
  hl.LspReferenceRead = { bg = c.shroud }
  hl.LspReferenceWrite = { bg = c.shroud, underline = true, sp = c.holy_nova }
  hl.LspSignatureActiveParameter = { fg = c.halo, bold = true, underline = true }
  hl.LspInlayHint = { fg = c.ashen_robe, bg = c.void, italic = true }
  hl.LspCodeLens = { fg = c.ashen_robe, italic = true }
  hl.LspInfoBorder = { link = "FloatBorder" }

  ---------------------------------------------------------------------------
  -- Diagnostics: Error Holy fire, Warn Ember, Info Power Word: Shield, Hint Naaru
  ---------------------------------------------------------------------------
  local diag = {
    Error = c.holy_fire,
    Warn = c.ember,
    Info = c.pw_shield,
    Hint = c.naaru,
    Ok = c.renew,
  }
  for name, col in pairs(diag) do
    hl["Diagnostic" .. name] = { fg = col }
    hl["DiagnosticVirtualText" .. name] = { fg = col, bg = blend(col, c.abyss, 0.10), italic = true }
    hl["DiagnosticVirtualLines" .. name] = { fg = col }
    hl["DiagnosticUnderline" .. name] = { undercurl = true, sp = col }
    hl["DiagnosticFloating" .. name] = { fg = col }
    hl["DiagnosticSign" .. name] = { fg = col }
  end
  hl.DiagnosticUnnecessary = { fg = c.ashen_robe }
  hl.DiagnosticDeprecated = { strikethrough = true, sp = c.ashen_robe }

  ---------------------------------------------------------------------------
  -- Plugins
  ---------------------------------------------------------------------------
  -- gitsigns: added Renew, changed Holy nova, removed Holy fire
  hl.GitSignsAdd = { fg = c.renew }
  hl.GitSignsChange = { fg = c.holy_nova }
  hl.GitSignsDelete = { fg = c.holy_fire }
  hl.GitSignsTopdelete = { link = "GitSignsDelete" }
  hl.GitSignsChangedelete = { fg = c.ember }
  hl.GitSignsUntracked = { fg = c.ashen_robe }
  hl.GitSignsCurrentLineBlame = { fg = c.ashen_robe, italic = true }
  hl.GitSignsAddInline = { bg = blend(c.renew, c.abyss, 0.25) }
  hl.GitSignsChangeInline = { bg = blend(c.holy_nova, c.abyss, 0.25) }
  hl.GitSignsDeleteInline = { bg = blend(c.holy_fire, c.abyss, 0.25) }
  hl.MiniDiffSignAdd = { link = "GitSignsAdd" }
  hl.MiniDiffSignChange = { link = "GitSignsChange" }
  hl.MiniDiffSignDelete = { link = "GitSignsDelete" }

  -- Telescope
  hl.TelescopeNormal = { link = "NormalFloat" }
  hl.TelescopeBorder = { link = "FloatBorder" }
  hl.TelescopeTitle = { link = "FloatTitle" }
  hl.TelescopePromptPrefix = { fg = c.halo }
  hl.TelescopePromptCounter = { fg = c.ashen_robe }
  hl.TelescopeSelection = { link = "Visual" }
  hl.TelescopeSelectionCaret = { fg = c.halo, bg = c.twilight_robe }
  hl.TelescopeMatching = { fg = c.holy_nova, bold = true }
  hl.TelescopeMultiSelection = { fg = c.penance }

  -- fzf-lua / snacks picker
  hl.FzfLuaBorder = { link = "FloatBorder" }
  hl.FzfLuaTitle = { link = "FloatTitle" }
  hl.FzfLuaCursorLine = { link = "Visual" }
  hl.SnacksPickerMatch = { fg = c.holy_nova, bold = true }
  hl.SnacksPickerPrompt = { fg = c.halo }
  hl.SnacksPickerDir = { fg = c.ashen_robe }
  hl.SnacksIndent = { fg = c.dusk }
  hl.SnacksIndentScope = { fg = c.shroud }
  hl.SnacksDashboardHeader = { fg = c.mind_flay }
  hl.SnacksDashboardKey = { fg = c.holy_nova }
  hl.SnacksDashboardIcon = { fg = c.void_bolt }
  hl.SnacksDashboardDesc = { fg = c.veil }
  hl.SnacksDashboardFooter = { fg = c.ashen_robe, italic = true }

  -- Completion (nvim-cmp and blink.cmp)
  hl.CmpItemAbbr = { fg = c.veil }
  hl.CmpItemAbbrMatch = { fg = c.holy_nova, bold = true }
  hl.CmpItemAbbrMatchFuzzy = { fg = c.holy_nova }
  hl.CmpItemAbbrDeprecated = { fg = c.ashen_robe, strikethrough = true }
  hl.CmpItemMenu = { fg = c.ashen_robe }
  hl.BlinkCmpMenu = { link = "Pmenu" }
  hl.BlinkCmpMenuBorder = { link = "FloatBorder" }
  hl.BlinkCmpMenuSelection = { link = "PmenuSel" }
  hl.BlinkCmpLabelMatch = { fg = c.holy_nova, bold = true }
  hl.BlinkCmpLabelDeprecated = { fg = c.ashen_robe, strikethrough = true }
  hl.BlinkCmpDoc = { link = "NormalFloat" }
  hl.BlinkCmpDocBorder = { link = "FloatBorder" }
  hl.BlinkCmpGhostText = { fg = c.ashen_robe, italic = true }

  local kinds = {
    Text = c.veil, Method = c.holy_nova, Function = c.holy_nova, Constructor = c.shadowfiend_light,
    Field = c.veil, Variable = c.priest_white, Class = c.shadowfiend_light, Interface = c.shadowfiend_light,
    Module = c.shadowfiend_light, Property = c.veil, Unit = c.ember, Value = c.ember,
    Enum = c.shadowfiend_light, Keyword = c.void_bolt, Snippet = c.penitent, Color = c.penance,
    File = c.abyssal_tide, Reference = c.naaru, Folder = c.void_bolt, EnumMember = c.penance,
    Constant = c.penance, Struct = c.shadowfiend_light, Event = c.insanity, Operator = c.mind_flay,
    TypeParameter = c.shadowfiend_light, Copilot = c.naaru,
  }
  for kind, col in pairs(kinds) do
    hl["CmpItemKind" .. kind] = { fg = col }
    hl["BlinkCmpKind" .. kind] = { fg = col }
  end

  -- Explorers (neo-tree, nvim-tree, oil, mini.files)
  hl.NeoTreeNormal = { fg = c.veil, bg = c.void }
  hl.NeoTreeNormalNC = { fg = c.veil, bg = c.void }
  hl.NeoTreeWinSeparator = { fg = c.void, bg = c.void }
  hl.NeoTreeDirectoryName = { fg = c.void_bolt }
  hl.NeoTreeDirectoryIcon = { fg = c.void_bolt }
  hl.NeoTreeRootName = { fg = c.holy_nova, bold = true }
  hl.NeoTreeFileNameOpened = { fg = c.halo }
  hl.NeoTreeGitAdded = { fg = c.renew }
  hl.NeoTreeGitModified = { fg = c.holy_nova }
  hl.NeoTreeGitDeleted = { fg = c.holy_fire }
  hl.NeoTreeGitConflict = { fg = c.insanity, bold = true }
  hl.NeoTreeGitUntracked = { fg = c.ashen_robe, italic = true }
  hl.NeoTreeIndentMarker = { fg = c.shroud }
  hl.NvimTreeNormal = { link = "NeoTreeNormal" }
  hl.NvimTreeWinSeparator = { link = "NeoTreeWinSeparator" }
  hl.NvimTreeFolderName = { fg = c.void_bolt }
  hl.NvimTreeOpenedFolderName = { fg = c.void_bolt, bold = true }
  hl.NvimTreeFolderIcon = { fg = c.void_bolt }
  hl.NvimTreeRootFolder = { fg = c.holy_nova, bold = true }
  hl.NvimTreeExecFile = { fg = c.holy_nova, bold = true }
  hl.NvimTreeIndentMarker = { fg = c.shroud }
  hl.OilDir = { fg = c.void_bolt, bold = true }
  hl.OilFile = { fg = c.priest_white }
  hl.MiniFilesTitleFocused = { fg = c.holy_nova, bg = float_bg, bold = true }

  -- which-key
  hl.WhichKey = { fg = c.holy_nova }
  hl.WhichKeyGroup = { fg = c.void_bolt }
  hl.WhichKeyDesc = { fg = c.veil }
  hl.WhichKeySeparator = { fg = c.ashen_robe }
  hl.WhichKeyNormal = { link = "NormalFloat" }
  hl.WhichKeyBorder = { link = "FloatBorder" }
  hl.WhichKeyValue = { fg = c.ashen_robe }

  -- Indent guides
  hl.IblIndent = { fg = c.dusk, nocombine = true }
  hl.IblScope = { fg = c.shroud, nocombine = true }
  hl.MiniIndentscopeSymbol = { fg = c.shroud }

  -- bufferline: active buffer is lit
  hl.BufferLineFill = { bg = c.void }
  hl.BufferLineBackground = { fg = c.ashen_robe, bg = c.void }
  hl.BufferLineBufferSelected = { fg = c.halo, bg = c.abyss, bold = true }
  hl.BufferLineIndicatorSelected = { fg = c.holy_nova, bg = c.abyss }

  -- noice / notify
  -- nvim-notify fades towards NotifyBackground, so it always needs a real colour,
  -- even in transparent mode. Abyss matches Kitty, so fades blend into what's behind.
  hl.NotifyBackground = { bg = c.abyss }
  for _, lvl in ipairs({ "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }) do
    hl["Notify" .. lvl .. "Body"] = { fg = c.priest_white, bg = float_bg }
  end
  hl.NoiceCmdlinePopupBorder = { link = "FloatBorder" }
  hl.NoiceCmdlineIcon = { fg = c.halo }
  hl.NoiceCmdlinePopupTitle = { link = "FloatTitle" }
  hl.NotifyERRORBorder = { fg = blend(c.holy_fire, c.abyss, 0.5) }
  hl.NotifyWARNBorder = { fg = blend(c.ember, c.abyss, 0.5) }
  hl.NotifyINFOBorder = { fg = blend(c.pw_shield, c.abyss, 0.5) }
  hl.NotifyDEBUGBorder = { fg = c.shroud }
  hl.NotifyTRACEBorder = { fg = blend(c.penitent, c.abyss, 0.5) }
  hl.NotifyERRORIcon = { fg = c.holy_fire }
  hl.NotifyWARNIcon = { fg = c.ember }
  hl.NotifyINFOIcon = { fg = c.pw_shield }
  hl.NotifyDEBUGIcon = { fg = c.ashen_robe }
  hl.NotifyTRACEIcon = { fg = c.penitent }
  hl.NotifyERRORTitle = { link = "NotifyERRORIcon" }
  hl.NotifyWARNTitle = { link = "NotifyWARNIcon" }
  hl.NotifyINFOTitle = { link = "NotifyINFOIcon" }
  hl.NotifyDEBUGTitle = { link = "NotifyDEBUGIcon" }
  hl.NotifyTRACETitle = { link = "NotifyTRACEIcon" }

  -- flash / leap: jump labels are lit
  hl.FlashLabel = { fg = c.abyss, bg = c.halo, bold = true }
  hl.FlashMatch = { fg = c.void_bolt }
  hl.FlashCurrent = { fg = c.holy_nova, bold = true }
  hl.FlashBackdrop = { fg = c.ashen_robe }
  hl.LeapLabel = { link = "FlashLabel" }

  -- Lazy / Mason
  hl.LazyH1 = { fg = c.abyss, bg = c.holy_nova, bold = true }
  hl.LazyButton = { fg = c.veil, bg = c.dusk }
  hl.LazyButtonActive = { fg = c.abyss, bg = c.holy_nova, bold = true }
  hl.LazySpecial = { fg = c.void_bolt }
  hl.LazyProgressDone = { fg = c.holy_nova }
  hl.LazyProgressTodo = { fg = c.shroud }
  hl.MasonHeader = { link = "LazyH1" }
  hl.MasonHighlight = { fg = c.holy_nova }
  hl.MasonHighlightBlock = { fg = c.abyss, bg = c.holy_nova }
  hl.MasonHighlightBlockBold = { fg = c.abyss, bg = c.holy_nova, bold = true }
  hl.MasonMuted = { fg = c.ashen_robe }

  -- Treesitter context
  hl.TreesitterContext = { bg = c.void }
  hl.TreesitterContextLineNumber = { fg = c.ashen_robe, bg = c.void }
  hl.TreesitterContextBottom = { underline = true, sp = c.shroud }

  -- rainbow-delimiters: walk the wheel from shadow through twilight into light
  hl.RainbowDelimiterRed = { fg = c.void_bolt }
  hl.RainbowDelimiterYellow = { fg = c.holy_nova }
  hl.RainbowDelimiterBlue = { fg = c.shadowfiend_light }
  hl.RainbowDelimiterOrange = { fg = c.ember }
  hl.RainbowDelimiterGreen = { fg = c.renew }
  hl.RainbowDelimiterViolet = { fg = c.penitent }
  hl.RainbowDelimiterCyan = { fg = c.naaru }

  -- Trouble
  hl.TroubleNormal = { fg = c.veil, bg = c.void }
  hl.TroubleNormalNC = { fg = c.veil, bg = c.void }
  hl.TroubleCount = { fg = c.abyss, bg = c.penance, bold = true }

  -- Built-in statusline helpers (used by duality.statusline)
  local sl = {
    DualityModeNormal = { fg = c.priest_white, bg = c.mind_flay, bold = true },
    DualityModeInsert = { fg = c.abyss, bg = c.holy_nova, bold = true },
    DualityModeVisual = { fg = c.abyss, bg = c.penance, bold = true },
    DualityModeReplace = { fg = c.abyss, bg = c.holy_fire, bold = true },
    DualityModeCommand = { fg = c.abyss, bg = c.halo, bold = true },
    DualityModeTerminal = { fg = c.abyss, bg = c.old_gods_eye, bold = true },
    DualityGit = { fg = c.abyss, bg = c.ember, bold = true },
    DualityFile = { fg = c.abyss, bg = c.penance },
    DualityDiag = { fg = c.priest_white, bg = c.umbral },
    DualityFiletype = { fg = c.halo, bg = c.twilight_robe },
    DualityClock = { fg = c.veil, bg = c.dusk },
    DualityFill = { fg = c.ashen_robe, bg = c.void },
    DualityDiagError = { fg = c.holy_fire, bg = c.umbral, bold = true },
    DualityDiagWarn = { fg = c.ember, bg = c.umbral, bold = true },
  }
  for k, v in pairs(sl) do
    hl[k] = v
  end

  return hl
end

return M
