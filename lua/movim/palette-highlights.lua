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
