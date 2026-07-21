-- help
-- vim.opt.clipboard    = "unamedplus"        -- Allows neovim to access the system clipboard
vim.opt.fileencoding   = "utf-8"             -- The encoding written to a file
vim.opt.cmdheight      = 2                   -- More space in neovim command line
-- vim.opt.smartindent    = true                -- Auto indent on new line (disabled in favor of Treesitter)
vim.opt.mouse          = "a"                 -- Allow for mouse control
vim.opt.splitbelow     = true                -- Force all horizontal splits to go below current buffer
vim.opt.splitright     = true                -- Force all vertical splits to go to the right of buffer
vim.opt.expandtab      = true                -- Convert tabs into spaces
vim.opt.shiftwidth     = 2                   -- How many coloumns to indent
vim.opt.tabstop        = 2                   -- How many spaces to insert on tab
vim.opt.undofile       = true                -- Enables persistent undos
vim.opt.number         = true                -- Show line numbers
vim.opt.relativenumber = true                -- Show relative line numbers
vim.opt.scrolloff      = 8                   -- Minimum number of lines to keep above and below cursor
if vim.g.neovide then
  vim.opt.guifont = "CaskaydiaCove Nerd Font Mono:h13"
end
vim.opt.textwidth      = 0                   -- Disable automatic text wrapping (0 = no limit)
vim.opt.swapfile       = false               -- Enable/Disable Swap file
vim.opt.pumblend       = 20                  -- Psuedo transparency for the popup-menu
vim.opt.termguicolors  = true                -- Enable gui terminal colors
vim.opt.wrapmargin     = 0                   -- Disable wrap margin
vim.opt.completeopt    ={"menu", "menuone", "noselect", "noinsert"}
vim.opt.formatoptions  = "cqj"              -- Remove 't' to disable auto-wrapping of text
vim.opt.wrap           = false               -- Disable visual line wrapping
-- vim.opt.gcr           += "i:ver100-iCursor"

-- UFO folding settings
vim.opt.foldcolumn     = '0'                 -- Hide fold column (set to '1' to show)
vim.opt.foldlevel      = 99                  -- Using ufo provider need a large value, feel free to decrease
vim.opt.foldlevelstart = 99                  -- Start with all folds open
vim.opt.foldenable     = true                -- Enable folding
