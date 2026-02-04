-- Window / Buffer keybinds --
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', {})
vim.api.nvim_set_keymap('n', '<leader><Tab>', '<C-^>', {})

-- LSP Bindings --
-- vim.api.nvim_set_keymap('n', '<leader>lf', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lf',
  [[:lua if vim.bo.filetype == 'python' then vim.cmd('write | !black %') else vim.lsp.buf.format({ async = true }) end<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':lua vim.lsp.buf.code_action()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>lk', ':lua vim.lsp.buf.hover()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>lr', ':e<CR>', {})
vim.api.nvim_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', {})

-- Buffer keybinds --
vim.api.nvim_set_keymap('n', '<leader>]', ':bnext<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>[', ':bprev<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>d', ':bd<CR>', {})


-- Jumpto Directory keybinds --
vim.api.nvim_set_keymap('n', '<leader>cdn', ':e ~/.config/nvim/init.lua<CR>', {})

-- General Keybinds --
vim.api.nvim_set_keymap('n', '<leader>o', ':setlocal spell! spelllang=en_us<CR>', {})
vim.api.nvim_set_keymap('n', '<leader><leader>', ':w<CR>', {})
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><CR>', { noremap = true })
-- vim.api.nvim_set_keymap('i', '<expr> <Tab>', 'search("\\%#[]>)}$\'\'"`]", "n") ? "<Right>" : "<Tab>"', { noremap = true })
-- vim.api.nvim_set_keymap('n', 'J', 'ddp', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'K', 'ddkP', { noremap = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':!make<CR>', { noremap = true, silent = true })

-- Telescope Keybinds --
vim.api.nvim_set_keymap('n', '<leader>gs', ':Neogit<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fp', ':Telescope git_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cc', ':Telescope colorscheme<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>Telescope lsp_definitions<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', "<cmd>Telescope lsp_references<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', ':Telescope keymaps<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':Telescope spell_suggest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ld', ':Telescope diagnostics<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ll', ':lua require("telescope.builtin").lsp_document_symbols()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lm', ':lua require("telescope.builtin").lsp_document_symbols({ symbols = {"method"} })<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lc', ':lua require("telescope.builtin").lsp_document_symbols({ symbols = {"class"} })<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lv', ':lua require("telescope.builtin").lsp_document_symbols({ symbols = {"variable"} })<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lF', ':lua require("telescope.builtin").lsp_document_symbols({ symbols = {"function"} })<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lt', '<cmd>TodoTelescope<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ln', '<cmd>Navbuddy<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', { noremap = true, silent = true })

-- Custom search: case insensitive, space = wildcard (.*) 
-- Example: "dov shamp" matches "dove shampoo"
vim.keymap.set('n', '/', function()
  -- Prompt for search input
  local input = vim.fn.input('/')
  if input == '' then
    return
  end
  -- Replace spaces with .* for wildcard matching
  local pattern = input:gsub(' ', '.*')
  -- Set the search register and perform case-insensitive search
  vim.fn.setreg('/', '\\c' .. pattern)
  -- Jump to first match
  vim.cmd('normal! n')
end, { noremap = true, silent = true })

-- Fugitive Git Conflict Resolution Keybinds --
vim.api.nvim_set_keymap('n', '<leader>gm', ':Gvdiffsplit!<CR>', { noremap = true, silent = true }) -- 3-way merge view
vim.api.nvim_set_keymap('n', '<leader>gh', ':diffget //2<CR>', { noremap = true, silent = true })  -- get from left (HEAD/target)
vim.api.nvim_set_keymap('n', '<leader>gl', ':diffget //3<CR>', { noremap = true, silent = true })  -- get from right (merge branch)
vim.api.nvim_set_keymap('n', '<leader>gw', ':Gwrite<CR>', { noremap = true, silent = true })       -- stage resolved file


vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward-to)')


-- This tabs out of the closing chars: ")]} etc.
_G.smart_tab = function()
  local chars = [=[[]>)}$''"`]]=]
  if vim.fn.search(chars, 'n') ~= 0 then
    -- The return is interpreted literally rather than as a string
    -- Use nvim_replace_termcodes to properly encode the key sequence
    return vim.api.nvim_replace_termcodes('<Right>', true, true, true)
  else
    return vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
  end
end
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', { expr = true, noremap = true, silent = true })



-- Function to copy file path in folder/folder/filename.ext format
_G.copy_file_path = function()
  -- Get the current file path relative to the current working directory
  local filepath = vim.fn.expand("%:.")
  
  -- Copy to system clipboard
  vim.fn.setreg("+", filepath)
  
  -- Show a message to confirm the copy
  vim.notify("Copied to clipboard: " .. filepath)
end

-- Set the keybinding for copying file path
vim.api.nvim_set_keymap('n', '<leader>cp', ':lua copy_file_path()<CR>', { noremap = true, silent = true })

-- Set the keybind for opening

-- Neovide Font Scaling --
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0

  local function change_scale_factor(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  vim.keymap.set("n", "<C-=>", function() change_scale_factor(1.1) end, { noremap = true, silent = true, desc = "Neovide: Increase font size" })
  vim.keymap.set("n", "<C-->", function() change_scale_factor(1/1.1) end, { noremap = true, silent = true, desc = "Neovide: Decrease font size" })
end
