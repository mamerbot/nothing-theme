vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "light"
vim.g.colors_name = "nothing-light"

local c = {
  bg = "#FFFFFF",
  surface = "#FFFFFF",
  raised = "#F0F0F0",
  border = "#E8E8E8",
  split = "#CCCCCC",
  disabled = "#999999",
  muted = "#666666",
  fg = "#1A1A1A",
  bright = "#000000",
  red = "#D71921",
  green = "#4A9E5C",
  yellow = "#D4A843",
  blue = "#007AFF",
  magenta = "#7A4FA8",
  cyan = "#2A8FAF",
}

local terminal = {
  "#1A1A1A",
  "#D71921",
  "#4A9E5C",
  "#D4A843",
  "#007AFF",
  "#7A4FA8",
  "#2A8FAF",
  "#CCCCCC",
  "#666666",
  "#D71921",
  "#4A9E5C",
  "#D4A843",
  "#007AFF",
  "#7A4FA8",
  "#2A8FAF",
  "#000000",
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
