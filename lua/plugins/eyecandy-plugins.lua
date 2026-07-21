return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require('vscode').setup({
        style = 'dark',
        italic_comments = true,
      })
      vim.cmd([[colorscheme vscode]])
    end
  },

  { "nvim-telescope/telescope.nvim" }, -- popup windows
  { 'MunifTanjim/prettier.nvim' },     -- opinionated formatter
  { "stevearc/dressing.nvim" },        -- popup window for mason filter language
  { "nvim-telescope/telescope-ui-select.nvim" },      -- popup telescope window on select prompts
  { "stevearc/dressing.nvim" },        -- popup window for mason filter language
  { "machakann/vim-highlightedyank" }, -- highlight the yanked text
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local lualine = require('lualine')
      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          always_divide_middle = true,
          disabled_filetypes = { "neo-tree" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              path = 1,            -- Display full file path
              file_status = true,  -- Show file status (modified, etc.)
              path_separator = ' > ' -- Separator between folder and file name
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = {
            {
              function()
                if _G.fuzzy_qf_status then
                  return _G.fuzzy_qf_status()
                end
                return ""
              end
            },
            "progress"
          },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end
  },
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- eye candy icons for nvim-tree
  { 
    "lukas-reineke/indent-blankline.nvim", 
    main = "ibl", 
    opts = {
      exclude = {
        filetypes = {
          "dashboard",
          "help",
          "neo-tree",
        }
      }
    }
  },
  
  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("dashboard")
      local recent_projects = require("movim.recent-projects")
      recent_projects.setup_dashboard_mappings()

      dashboard.setup({
        theme = "hyper",
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {},
          project = { enable = false },
          mru = { enable = false },
          footer = function()
            local lines = recent_projects.dashboard_lines()
            vim.list_extend(lines, { "", "🚀 Let's build something cool" })
            return lines
          end,
        },
      })
      
      -- Set colors to match VSCode dark theme
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#569CD6" })  -- VSCode blue
      vim.api.nvim_set_hl(0, "DashboardCenter", { fg = "#FFFFFF" })  -- White
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#608B4E" })  -- VSCode green
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#FFFFFF" })    -- White
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#C586C0" })     -- VSCode purple
    end,
  },
}
