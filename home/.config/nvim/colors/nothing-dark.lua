vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "nothing-dark"

local c = {
  bg = "#000000",
  surface = "#111111",
  raised = "#1A1A1A",
  border = "#222222",
  split = "#333333",
  disabled = "#666666",
  muted = "#999999",
  fg = "#E8E8E8",
  bright = "#FFFFFF",
  red = "#D71921",
  green = "#4A9E5C",
  yellow = "#D4A843",
  blue = "#5B9BF6",
  magenta = "#9B6FBF",
  cyan = "#4A9EC4",
}

local terminal = {
  "#000000",
  "#D71921",
  "#4A9E5C",
  "#D4A843",
  "#5B9BF6",
  "#9B6FBF",
  "#4A9EC4",
  "#999999",
  "#333333",
  "#D71921",
  "#4A9E5C",
  "#D4A843",
  "#5B9BF6",
  "#9B6FBF",
  "#4A9EC4",
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
