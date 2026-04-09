return {
  "nvim-lua/popup.nvim",             -- required for a bunch of plugins
  "nvim-lua/plenary.nvim",           -- required for a bunch of plugins
  "tpope/vim-surround",              -- change Surround
  "tpope/vim-repeat",                -- hack vim .
  "tpope/vim-commentary",            -- gcc comments
  "ggandor/leap.nvim",               -- movement plugin
  "Shougo/neomru.vim",               -- track recently visitied files
  {
    'cameron-wags/rainbow_csv.nvim', -- rainbow csv
    config = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon'
    },
    cmd = {
      'RainbowDelim',
      'RainbowDelimSimple',
      'RainbowDelimQuoted',
      'RainbowMultiDelim'
    }
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>lp",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>lP",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- load once insert mode is entered
    opts = {}
  },                       -- insert closing brackets
  {
    'ThePrimeagen/harpoon',
    keys = {
      { "<C-h>",      "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",         desc = "Harpoon File 1" },
      { "<C-j>",      "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",         desc = "Harpoon File 2" },
      { "<C-k>",      "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",         desc = "Harpoon File 3" },
      { "<C-l>",      "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",         desc = "Harpoon File 4" },
      { "<C-e>",      "<cmd>lua require('harpoon.mark').add_file()<CR>",        desc = "Add a file to the shotlist" },
      { "<leader>hl", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "List the shotlist" }
    },
    lazy = false
  },
  {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
      },
      lazy = false,
      keys = {
        { "<C-n>", "<cmd>Neotree toggle=true<CR>" }
      },
      opts = {
        filesystem = {
          hijack_netrw_behavior = "open_current",
        },
      },
    }
  },

  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        auto_attach                  = true,
        attach_to_untracked          = false,
        current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 200,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        }
      }
    end
  },
  { "TimUntersberger/neogit", config = true }, -- neogit.
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' }
  },
  { "ahmedkhalf/project.nvim" },
  { "stevearc/oil.nvim" },
  {
    "m00qek/baleia.nvim",
    lazy = true,
    cmd = { "BaleiaColorize" },
  },
  {
    "folke/todo-comments.nvim",
    config = true, -- Uses defaults; customize as needed (see docs)
  },
  {
    "SmiteshP/nvim-navbuddy",
    cmd = "Navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = { lsp = { auto_attach = true } },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async"
    },
    config = function()
      local ftMap = {
        vim = 'indent',
        python = { 'indent' },
        git = ''
      }

      require('ufo').setup({
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        },
        provider_selector = function(bufnr, filetype, buftype)
          return ftMap[filetype]
        end
      })

      -- Keymaps
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
      
      -- Tab to toggle fold under cursor (disabled - conflicts with C-i jump forward)
      -- vim.keymap.set('n', '<Tab>', 'za', { desc = 'Toggle fold under cursor' })
      
      -- Peek fold with K in normal mode, fallback to LSP hover if not on a fold
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end
  }
}
