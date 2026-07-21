local M = {}

local uv = vim.uv or vim.loop
local cache_path = vim.fn.stdpath("cache") .. "/movim-recent-projects.json"
local project_roots = { vim.fn.expand("~/dev") }
local max_projects = 6
local excluded_projects = {
  [vim.fs.normalize(vim.fn.expand("~/dev/iinvy"))] = true,
}

local projects = {}

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

  local lines = { "󰏓  Recent Git Projects", "" }
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
