-- Polybar-palette color treatment for the dashboard-nvim dashboard and Neogit
-- ONLY. Everything else keeps the base vscode.nvim colorscheme untouched.
--
-- Re-applied on every ColorScheme so it survives scheme reloads. Neogit's own
-- highlight setup only fills groups that are not already set, so pre-setting
-- these makes our values win without reconfiguring the plugin.

local M = {}

-- Polybar palette
local palette = {
  purple   = "#7B5EA7",
  orange   = "#E8875B",
  lavender = "#C8C0D8",
  bg       = "#0B0E14",
  bg_alt   = "#151926",
  muted    = "#4A4560",
  red      = "#E84545",
}

-- Derived tones: muted/desaturated green for diff additions (green is only
-- kept where semantically needed), palette red for deletions, and a slightly
-- lifted bg_alt for the "active/cursor" hunk-header variants.
local add_fg      = "#8FB07A" -- muted desaturated green
local add_bg      = "#12251A"
local del_fg      = palette.red
local del_bg      = "#2A1418"
local hunk_hl_bg  = "#20263A" -- bg_alt lifted a touch for cursor/active rows

-- Derived tones for the rest of the UI chrome. Selections read purple, matches
-- and the current position read orange, floats sit on bg with a purple border.
-- Git/diff/diagnostics stay off green: add = purple, change = orange, delete/error
-- = red. (Neogit's own diff view above keeps its muted add green on purpose.)
local sel_bg      = "#2A2140" -- purple-tinted selection background
local sel_bg_dim  = "#231B33" -- dimmer variant for tree/list cursor rows
local search_bg   = "#3A2A16" -- dim orange for inactive search matches
local diff_add_bg = "#1C1A2B" -- purple-tinted add background
local diff_chg_bg = "#2A2416" -- orange-tinted change background
local diff_txt_bg = "#463A1E" -- brighter orange for the changed span

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

function M.apply()
  local p = palette

  -- ----- dashboard-nvim (hyper theme) -----
  hl("DashboardHeader",            { fg = p.purple, bold = true })  -- logo / week header
  hl("DashboardFooter",            { fg = p.muted })                -- subtle footer text
  hl("DashboardDesc",              { fg = p.lavender })
  hl("DashboardCenter",            { fg = p.lavender })
  hl("DashboardKey",               { fg = p.orange, bold = true })  -- shortcut keys
  hl("DashboardShortCut",          { fg = p.orange })
  hl("DashboardShortCutIcon",      { fg = p.orange })
  hl("DashboardIcon",              { fg = p.orange })
  hl("DashboardProjectTitle",      { fg = p.purple, bold = true })
  hl("DashboardProjectTitleIcon",  { fg = p.orange })
  hl("DashboardProjectIcon",       { fg = p.orange })
  hl("DashboardRecentProjectIcon", { fg = p.orange })
  hl("DashboardMruTitle",          { fg = p.purple, bold = true })
  hl("DashboardMruIcon",           { fg = p.orange })
  hl("DashboardFiles",             { fg = p.lavender })

  -- ----- Neogit -----
  -- Section headers purple (all the *changes / *files headers link to this)
  hl("NeogitSectionHeader",         { fg = p.purple, bold = true })
  hl("NeogitPopupSectionTitle",     { fg = p.purple, bold = true })

  -- Branch names orange
  hl("NeogitBranch",                { fg = p.orange, bold = true })
  hl("NeogitBranchHead",            { fg = p.orange, bold = true, underline = true })
  hl("NeogitRemote",                { fg = p.purple, bold = true }) -- was green

  -- Subtle metadata muted
  hl("NeogitObjectId",              { fg = p.muted })
  hl("NeogitStash",                 { fg = p.muted })
  hl("NeogitSubtleText",            { fg = p.muted })
  hl("NeogitFilePath",              { fg = p.lavender, italic = true })
  hl("NeogitTagName",               { fg = p.orange })

  -- Hunk headers on bg-alt
  hl("NeogitHunkHeader",            { fg = p.lavender, bg = p.bg_alt, bold = true })
  hl("NeogitHunkHeaderHighlight",   { fg = p.orange,   bg = hunk_hl_bg, bold = true })
  hl("NeogitHunkHeaderCursor",      { fg = p.orange,   bg = hunk_hl_bg, bold = true })
  hl("NeogitDiffHeader",            { fg = p.purple,   bg = p.bg_alt, bold = true })
  hl("NeogitDiffHeaderHighlight",   { fg = p.orange,   bg = p.bg_alt, bold = true })

  -- Diff add/delete: readable, muted green add + palette red delete
  hl("NeogitDiffAdd",               { fg = add_fg, bg = add_bg })
  hl("NeogitDiffAddHighlight",      { fg = add_fg, bg = add_bg, bold = true })
  hl("NeogitDiffAdditions",         { fg = add_fg })
  hl("NeogitDiffDelete",            { fg = del_fg, bg = del_bg })
  hl("NeogitDiffDeleteHighlight",   { fg = del_fg, bg = del_bg, bold = true })
  hl("NeogitDiffDeletions",         { fg = del_fg })

  -- Change markers: keep the green ones muted, delete red
  hl("NeogitChangeAdded",           { fg = add_fg, bold = true, italic = true })
  hl("NeogitChangeNewFile",         { fg = add_fg, bold = true, italic = true })
  hl("NeogitChangeDeleted",         { fg = del_fg, bold = true, italic = true })

  -- Popup keys orange (shortcuts)
  hl("NeogitPopupActionKey",        { fg = p.orange })
  hl("NeogitPopupSwitchKey",        { fg = p.orange })
  hl("NeogitPopupOptionKey",        { fg = p.orange })
  hl("NeogitPopupConfigKey",        { fg = p.orange })

  -- ----- core editor chrome -----
  -- Selection purple, current position + matches orange.
  hl("Visual",          { bg = sel_bg })
  hl("VisualNOS",       { bg = sel_bg })
  hl("CursorLineNr",    { fg = p.orange, bold = true })
  hl("Search",          { bg = search_bg })
  hl("IncSearch",       { fg = p.bg, bg = p.orange, bold = true })
  hl("CurSearch",       { fg = p.bg, bg = p.orange, bold = true })
  hl("Substitute",      { fg = p.bg, bg = p.orange, bold = true })
  hl("MatchParen",      { fg = p.orange, bold = true })
  hl("WildMenu",        { fg = p.lavender, bg = sel_bg })
  hl("QuickFixLine",    { bg = sel_bg, bold = true })
  hl("Folded",          { fg = p.muted, bg = p.bg_alt })
  hl("Title",           { fg = p.purple, bold = true })
  hl("Directory",       { fg = p.lavender })
  hl("Question",        { fg = p.purple })
  hl("MoreMsg",         { fg = p.purple })
  hl("ModeMsg",         { fg = p.lavender })
  hl("WinSeparator",    { fg = p.muted })
  hl("VertSplit",       { fg = p.muted })

  -- Popup menu (nvim-cmp rides on these) + floating windows.
  hl("Pmenu",           { fg = p.lavender, bg = p.bg_alt })
  hl("PmenuSel",        { fg = p.lavender, bg = sel_bg, bold = true })
  hl("PmenuSbar",       { bg = p.bg_alt })
  hl("PmenuThumb",      { bg = p.muted })
  hl("NormalFloat",     { fg = p.lavender, bg = p.bg })
  hl("FloatBorder",     { fg = p.purple, bg = p.bg })
  hl("FloatTitle",      { fg = p.orange, bg = p.bg, bold = true })

  -- ----- diagnostics (base groups; Sign/VirtualText/Float link to these) -----
  hl("DiagnosticInfo",  { fg = p.purple })
  hl("DiagnosticHint",  { fg = p.lavender })
  hl("DiagnosticOk",    { fg = p.purple }) -- was teal-green
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.purple })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.lavender })
  hl("DiagnosticUnderlineOk",   { undercurl = true, sp = p.purple })

  -- ----- diff + git: add = purple, change = orange, delete = red (no green) -----
  hl("DiffAdd",         { bg = diff_add_bg })
  hl("DiffChange",      { bg = diff_chg_bg })
  hl("DiffText",        { fg = p.orange, bg = diff_txt_bg })
  hl("DiffDelete",      { fg = del_fg, bg = del_bg })
  hl("Added",           { fg = p.purple })   -- lualine diff / VCS "added"
  hl("Changed",         { fg = p.orange })
  hl("Removed",         { fg = del_fg })

  hl("GitSignsAdd",     { fg = p.purple })
  hl("GitSignsChange",  { fg = p.orange })
  hl("GitSignsDelete",  { fg = del_fg })
  hl("GitSignsTopdelete",    { fg = del_fg })
  hl("GitSignsChangedelete", { fg = p.orange })
  hl("GitSignsUntracked",    { fg = p.muted })
  hl("GitSignsCurrentLineBlame", { fg = p.muted, italic = true })

  -- ----- telescope -----
  hl("TelescopeNormal",        { fg = p.lavender, bg = p.bg })
  hl("TelescopePromptNormal",  { fg = p.lavender, bg = p.bg_alt })
  hl("TelescopeBorder",        { fg = p.purple, bg = p.bg })
  hl("TelescopePromptBorder",  { fg = p.purple, bg = p.bg_alt })
  hl("TelescopeTitle",         { fg = p.orange, bold = true })
  hl("TelescopePromptPrefix",  { fg = p.orange })
  hl("TelescopePromptCounter", { fg = p.muted })
  hl("TelescopeSelection",      { fg = p.lavender, bg = sel_bg, bold = true })
  hl("TelescopeSelectionCaret", { fg = p.orange, bg = sel_bg })
  hl("TelescopeMatching",       { fg = p.orange, bold = true })

  -- ----- neo-tree -----
  hl("NeoTreeNormal",        { fg = p.lavender, bg = p.bg })
  hl("NeoTreeNormalNC",      { fg = p.lavender, bg = p.bg })
  hl("NeoTreeRootName",      { fg = p.purple, bold = true })
  hl("NeoTreeDirectoryName", { fg = p.lavender })
  hl("NeoTreeDirectoryIcon", { fg = p.purple })
  hl("NeoTreeFileNameOpened",{ fg = p.orange })
  hl("NeoTreeIndentMarker",  { fg = p.muted })
  hl("NeoTreeCursorLine",    { bg = sel_bg_dim })
  hl("NeoTreeTitleBar",      { fg = p.bg, bg = p.purple, bold = true })
  hl("NeoTreeGitAdded",      { fg = p.purple })
  hl("NeoTreeGitStaged",     { fg = p.purple })
  hl("NeoTreeGitModified",   { fg = p.orange })
  hl("NeoTreeGitUntracked",  { fg = p.muted })
  hl("NeoTreeGitDeleted",    { fg = del_fg })
  hl("NeoTreeGitConflict",   { fg = del_fg, bold = true })
  hl("NeoTreeSymbolicLinkTarget", { fg = p.orange })

  -- ----- completion item accents (nvim-cmp) -----
  hl("CmpItemAbbr",           { fg = p.lavender })
  hl("CmpItemAbbrMatch",      { fg = p.orange, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.orange })
  hl("CmpItemAbbrDeprecated", { fg = p.muted, strikethrough = true })
  hl("CmpItemMenu",           { fg = p.muted, italic = true })
  hl("CmpItemKind",           { fg = p.purple })

  -- ----- leap motion labels -----
  hl("LeapMatch",          { fg = p.orange, bold = true, underline = true })
  hl("LeapLabelPrimary",   { fg = p.bg, bg = p.orange, bold = true })
  hl("LeapLabelSecondary", { fg = p.bg, bg = p.purple, bold = true })
  hl("LeapBackdrop",       { fg = p.muted })

  -- ----- misc plugin chrome -----
  hl("IblScope",           { fg = p.purple })      -- indent-blankline current scope
  hl("HighlightedyankRegion", { bg = search_bg })  -- vim-highlightedyank flash
  hl("FidgetTitle",        { fg = p.purple, bold = true })
  hl("FidgetTask",         { fg = p.muted })
  hl("TroubleCount",       { fg = p.orange, bold = true })
  hl("TroubleNormal",      { fg = p.lavender, bg = p.bg })
  hl("OilDir",             { fg = p.lavender })
  hl("OilDirIcon",         { fg = p.purple })
  hl("OilCreate",          { fg = p.purple })
  hl("OilChange",          { fg = p.orange })
  hl("OilCopy",            { fg = p.orange })
  hl("OilMove",            { fg = p.orange })
  hl("OilDelete",          { fg = del_fg })

  -- ----- lazy.nvim + mason UIs (both default to green) -----
  hl("LazyH1",            { fg = p.bg, bg = p.purple, bold = true })
  hl("LazyButton",        { fg = p.lavender, bg = p.bg_alt })
  hl("LazyButtonActive",  { fg = p.bg, bg = p.orange, bold = true })
  hl("LazyProgressDone",  { fg = p.purple })
  hl("LazyProgressTodo",  { fg = p.muted })
  hl("LazySpecial",       { fg = p.orange })
  hl("MasonHeader",         { fg = p.bg, bg = p.purple, bold = true })
  hl("MasonHeaderSecondary",{ fg = p.bg, bg = p.orange, bold = true })
  hl("MasonHighlight",      { fg = p.purple })
  hl("MasonHighlightBlock", { fg = p.bg, bg = p.orange })
  hl("MasonHighlightBlockBold", { fg = p.bg, bg = p.orange, bold = true })
  hl("MasonMuted",          { fg = p.muted })
  hl("MasonMutedBlock",     { fg = p.lavender, bg = p.bg_alt })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("MovimPaletteHighlights", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = M.apply,
  })
  -- Apply now: the initial `colorscheme` was set during plugin load, before
  -- this autocmd existed, so the first paint needs an explicit call.
  M.apply()
end

return M
