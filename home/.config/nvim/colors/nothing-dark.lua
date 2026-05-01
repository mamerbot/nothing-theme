vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "nothing-dark"

local c = {
  bg = "#090807",
  surface = "#181614",
  raised = "#1D1A17",
  border = "#3A3632",
  split = "#3A3632",
  disabled = "#5A5248",
  muted = "#5A5248",
  fg = "#E5DDD0",
  bright = "#FFFFFF",
  accent = "#FF4719",
  red = "#D71921",
  green = "#5AB87A",
  yellow = "#E8A030",
  blue = "#4A8FD9",
  magenta = "#9575CD",
  cyan = "#26C6C6",
}

local terminal = {
  "#181614",
  "#D71921",
  "#5AB87A",
  "#E8A030",
  "#4A8FD9",
  "#9575CD",
  "#26C6C6",
  "#E5DDD0",
  "#3A3632",
  "#FF3B3B",
  "#7DD89A",
  "#FFB84D",
  "#70ADEC",
  "#B39DDB",
  "#4DD9D9",
  "#FFFFFF",
}

for i, color in ipairs(terminal) do
  vim.g["terminal_color_" .. (i - 1)] = color
end

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.surface })
hl("FloatBorder", { fg = c.border, bg = c.surface })
hl("Comment", { fg = c.disabled, italic = true })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.yellow })
hl("Float", { fg = c.yellow })
hl("Boolean", { fg = c.red })
hl("Constant", { fg = c.magenta })
hl("Keyword", { fg = c.red })
hl("Statement", { fg = c.red })
hl("Conditional", { fg = c.red })
hl("Repeat", { fg = c.red })
hl("Function", { fg = c.blue })
hl("Identifier", { fg = c.fg })
hl("Type", { fg = c.magenta })
hl("StorageClass", { fg = c.magenta })
hl("Structure", { fg = c.magenta })
hl("Operator", { fg = c.muted })
hl("Delimiter", { fg = c.muted })
hl("Special", { fg = c.cyan })
hl("SpecialChar", { fg = c.cyan })
hl("PreProc", { fg = c.cyan })
hl("Include", { fg = c.cyan })
hl("Define", { fg = c.magenta })
hl("Macro", { fg = c.magenta })
hl("Error", { fg = c.red, bold = true })
hl("ErrorMsg", { fg = c.red, bold = true })
hl("Todo", { fg = c.yellow, bg = c.raised, bold = true })
hl("CursorLine", { bg = c.raised })
hl("Visual", { bg = c.split })
hl("LineNr", { fg = c.muted })
hl("CursorLineNr", { fg = c.bright, bold = true })
hl("StatusLine", { fg = c.fg, bg = c.raised })
hl("StatusLineNC", { fg = c.muted, bg = c.border })
hl("Pmenu", { fg = c.fg, bg = c.raised })
hl("PmenuSel", { fg = c.bg, bg = c.blue })
hl("Search", { fg = c.bg, bg = c.yellow })
hl("IncSearch", { fg = c.bg, bg = c.blue })
hl("MatchParen", { fg = c.blue, bg = c.raised, bold = true })
hl("Directory", { fg = c.blue, bold = true })
hl("Title", { fg = c.bright, bold = true })
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.cyan })
hl("DiffAdd", { fg = c.green, bg = c.raised })
hl("DiffDelete", { fg = c.red, bg = c.raised })
hl("DiffChange", { fg = c.yellow, bg = c.raised })
hl("DiffText", { fg = c.bright, bg = c.split, bold = true })

-- Treesitter semantic groups
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.red })
hl("@variable.parameter", { fg = c.fg })
hl("@variable.member", { fg = c.blue })
hl("@string", { fg = c.green })
hl("@string.escape", { fg = c.cyan })
hl("@string.special", { fg = c.cyan })
hl("@number", { fg = c.yellow })
hl("@number.float", { fg = c.yellow })
hl("@boolean", { fg = c.red })
hl("@constant", { fg = c.magenta })
hl("@constant.builtin", { fg = c.red })
hl("@constant.macro", { fg = c.magenta })
hl("@keyword", { fg = c.red })
hl("@keyword.return", { fg = c.red })
hl("@keyword.function", { fg = c.red })
hl("@keyword.operator", { fg = c.muted })
hl("@keyword.import", { fg = c.cyan })
hl("@function", { fg = c.blue })
hl("@function.builtin", { fg = c.blue })
hl("@function.call", { fg = c.blue })
hl("@function.method", { fg = c.blue })
hl("@function.method.call", { fg = c.blue })
hl("@constructor", { fg = c.blue })
hl("@type", { fg = c.magenta })
hl("@type.builtin", { fg = c.magenta })
hl("@type.definition", { fg = c.magenta })
hl("@attribute", { fg = c.magenta })
hl("@property", { fg = c.blue })
hl("@operator", { fg = c.muted })
hl("@punctuation.delimiter", { fg = c.muted })
hl("@punctuation.bracket", { fg = c.muted })
hl("@comment", { fg = c.disabled, italic = true })
hl("@tag", { fg = c.red })
hl("@tag.attribute", { fg = c.magenta })
hl("@tag.delimiter", { fg = c.muted })
hl("@module", { fg = c.cyan })
hl("@namespace", { fg = c.cyan })
hl("@regex", { fg = c.red })
hl("@diff.plus", { fg = c.green })
hl("@diff.minus", { fg = c.red })
hl("@diff.delta", { fg = c.yellow })
