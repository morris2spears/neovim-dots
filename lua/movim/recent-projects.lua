local M = {}

local uv = vim.uv or vim.loop
local cache_path = vim.fn.stdpath("cache") .. "/movim-recent-projects.json"
local project_roots = { vim.fn.expand("~/dev") }
local max_projects = 6
local excluded_projects = {
  [vim.fs.normalize(vim.fn.expand("~/dev/iinvy"))] = true,
}

local projects = {}
local dashboard_highlight_ns = vim.api.nvim_create_namespace("MovimDashboardProjects")
-- dashboard-nvim paints the complete footer at priority 4096. These marks
-- intentionally sit above that footer layer while remaining buffer-local.
local dashboard_highlight_priority = 8192

local function setup_dashboard_highlights()
  -- Keep these local to dashboard content; the global VSCode colorscheme and
  -- plugin highlights remain untouched. Colors match the polybar palette used
  -- in lua/movim/palette-highlights.lua (purple heading, orange key/accent,
  -- lavender name, muted age).
  vim.api.nvim_set_hl(0, "MovimDashboardProjectHeading", { fg = "#7B5EA7", bold = true })
  vim.api.nvim_set_hl(0, "MovimDashboardProjectKey", { fg = "#E8875B", bold = true })
  vim.api.nvim_set_hl(0, "MovimDashboardProjectName", { fg = "#C8C0D8" })
  vim.api.nvim_set_hl(0, "MovimDashboardIinvy", { fg = "#E8875B", bold = true })
  vim.api.nvim_set_hl(0, "MovimDashboardProjectAge", { fg = "#4A4560", italic = true })
  -- hyper theme hardcodes the startup-stats lines to the `Comment` group
  -- (green in vscode.nvim); repaint them muted to match DashboardFooter.
  vim.api.nvim_set_hl(0, "MovimDashboardStartup", { fg = "#4A4560" })
end

local function highlight_dashboard_projects(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  setup_dashboard_highlights()
  vim.api.nvim_buf_clear_namespace(buf, dashboard_highlight_ns, 0, -1)

  for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    -- Startup stats lines (hyper theme paints these with `Comment` = green).
    if line:match("^%s*Startuptime:") or line:match("^%s*Plugins:") or line:match("^%s*neovim loaded ") then
      local content_start = line:find("%S")
      if content_start then
        vim.api.nvim_buf_set_extmark(buf, dashboard_highlight_ns, row - 1, content_start - 1, {
          end_col = #line,
          hl_group = "MovimDashboardStartup",
          priority = dashboard_highlight_priority,
          hl_mode = "replace",
        })
      end
    end

    local heading_start = line:find("Recent Git Projects", 1, true)
    if heading_start then
      local content_start = line:find("%S") or heading_start
      vim.api.nvim_buf_set_extmark(buf, dashboard_highlight_ns, row - 1, content_start - 1, {
        end_col = #line,
        hl_group = "MovimDashboardProjectHeading",
        priority = dashboard_highlight_priority,
        hl_mode = "replace",
      })
    end

    local key, name, age = line:match("%[([in%d])%]%s+(%S+)%s*(%S*)$")
    if key and name then
      local key_start = line:find("[" .. key .. "]", 1, true)
      local name_start = line:find(name, key_start + #key + 2, true)
      if key_start and name_start then
        vim.api.nvim_buf_set_extmark(buf, dashboard_highlight_ns, row - 1, key_start - 1, {
          end_col = key_start + #key + 1,
          hl_group = "MovimDashboardProjectKey",
          priority = dashboard_highlight_priority,
          hl_mode = "replace",
        })
        vim.api.nvim_buf_set_extmark(buf, dashboard_highlight_ns, row - 1, name_start - 1, {
          end_col = name_start - 1 + #name,
          hl_group = key == "i" and "MovimDashboardIinvy" or "MovimDashboardProjectName",
          priority = dashboard_highlight_priority,
          hl_mode = "replace",
        })
      end

      if age ~= "" then
        local age_start = line:find(age, name_start + #name, true)
        if age_start then
          vim.api.nvim_buf_set_extmark(buf, dashboard_highlight_ns, row - 1, age_start - 1, {
            end_col = age_start - 1 + #age,
            hl_group = "MovimDashboardProjectAge",
            priority = dashboard_highlight_priority,
            hl_mode = "replace",
          })
        end
      end
    end
  end
end

local function read_cache()
  local ok, lines = pcall(vim.fn.readfile, cache_path)
  if not ok or #lines == 0 then
    return {}
  end

  local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded_ok and type(decoded) == "table" and decoded or {}
end

local function write_cache(cache)
  pcall(vim.fn.mkdir, vim.fs.dirname(cache_path), "p")
  pcall(vim.fn.writefile, { vim.json.encode(cache) }, cache_path)
end

local function git_output(path, args)
  local command = { "git", "-C", path }
  vim.list_extend(command, args)
  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout or "")
end

local function git_dir_mtime(path)
  local git_dir = git_output(path, { "rev-parse", "--absolute-git-dir" })
  if not git_dir then
    return 0
  end

  local stat = uv.fs_stat(git_dir .. "/logs/HEAD") or uv.fs_stat(git_dir .. "/HEAD")
  return stat and stat.mtime and stat.mtime.sec or 0
end

local function discover_projects()
  local found = {}
  for _, root in ipairs(project_roots) do
    if vim.fn.isdirectory(root .. "/.git") == 1 or vim.fn.filereadable(root .. "/.git") == 1 then
      found[root] = true
    end

    local ok, iterator = pcall(vim.fs.dir, root)
    if ok and iterator then
      for name, kind in iterator do
        if kind == "directory" then
          local path = vim.fs.normalize(root .. "/" .. name)
          if vim.fn.isdirectory(path .. "/.git") == 1 or vim.fn.filereadable(path .. "/.git") == 1 then
            found[path] = true
          end
        end
      end
    end
  end

  local paths = vim.tbl_keys(found)
  table.sort(paths)
  return paths
end

local function relative_age(timestamp)
  local seconds = math.max(0, os.time() - timestamp)
  if seconds < 3600 then
    return math.max(1, math.floor(seconds / 60)) .. "m"
  elseif seconds < 86400 then
    return math.floor(seconds / 3600) .. "h"
  elseif seconds < 604800 then
    return math.floor(seconds / 86400) .. "d"
  end
  return math.floor(seconds / 604800) .. "w"
end

local function refresh_projects()
  local cache = read_cache()
  local email = git_output(project_roots[1], { "config", "user.email" })
  local refreshed = {}

  projects = {}
  for _, path in ipairs(discover_projects()) do
    if not excluded_projects[path] then
      local head_mtime = git_dir_mtime(path)
      local cached = cache[path]
      local timestamp

      if cached and cached.head_mtime == head_mtime then
        timestamp = cached.timestamp
      else
        local author_arg = email and email ~= "" and ("--author=" .. email) or nil
        local args = { "log", "-1", "--format=%ct" }
        if author_arg then
          table.insert(args, author_arg)
        end
        timestamp = tonumber(git_output(path, args))
          or tonumber(git_output(path, { "log", "-1", "--format=%ct" }))
          or head_mtime
      end

      timestamp = tonumber(timestamp) or 0
      refreshed[path] = { head_mtime = head_mtime, timestamp = timestamp }
      table.insert(projects, {
        name = vim.fs.basename(path),
        path = path,
        timestamp = math.max(timestamp, head_mtime),
      })
    end
  end

  write_cache(refreshed)
  table.sort(projects, function(a, b)
    if a.timestamp == b.timestamp then
      return a.name < b.name
    end
    return a.timestamp > b.timestamp
  end)
end

function M.dashboard_lines()
  refresh_projects()

  local lines = { "󰏓  Recent Git Projects", "", "[i]  iinvy", "[n]  nvim-config" }
  for index, project in ipairs(projects) do
    if index > max_projects then
      break
    end
    table.insert(lines, string.format("[%d]  %-28s %s", index, project.name, relative_age(project.timestamp)))
  end

  if #projects == 0 then
    table.insert(lines, "No recent Git projects found")
  end

  return lines
end

function M.setup_dashboard_mappings()
  local group = vim.api.nvim_create_augroup("MovimDashboardProjects", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "DashboardLoaded",
    callback = function()
      highlight_dashboard_projects(vim.api.nvim_get_current_buf())
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "dashboard",
    callback = function(event)
      for index = 1, max_projects do
        vim.keymap.set("n", tostring(index), function()
          M.open(index)
        end, { buffer = event.buf, nowait = true, desc = "Open recent Git project " .. index })
      end

      vim.keymap.set("n", "i", function()
        vim.api.nvim_set_current_dir(vim.fn.expand("~/dev/iinvy"))
        vim.cmd("Neogit")
      end, { buffer = event.buf, nowait = true, desc = "Open iinvy in Neogit" })

      vim.keymap.set("n", "n", function()
        vim.api.nvim_set_current_dir(vim.fn.stdpath("config"))
        vim.cmd("Neogit")
      end, { buffer = event.buf, nowait = true, desc = "Open Neovim config in Neogit" })
    end,
  })
end

function M.open(index)
  local project = projects[index]
  if not project or vim.fn.isdirectory(project.path) ~= 1 then
    vim.notify("Recent project is no longer available", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_set_current_dir(project.path)
  local ok = pcall(vim.cmd, "Neogit")
  if not ok then
    vim.notify("Neogit is unavailable; opened " .. project.path, vim.log.levels.WARN)
    vim.cmd.edit(project.path)
  end
end

return M
