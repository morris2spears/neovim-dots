vim.g.mapleader = " "
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.updatetime = 100
vim.opt.clipboard = "unnamedplus"


-- Bootstrap LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")


vim.cmd("source ~/.config/nvim/main.vim")
require("movim.options")
require("movim.keybinds")
require("movim.palette-highlights").setup()




