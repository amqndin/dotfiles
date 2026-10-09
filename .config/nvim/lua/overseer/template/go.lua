-- Go projects: any directory containing a go.mod.
--
-- The entry point is discovered rather than assumed: `cmd/<name>/main.go` is
-- the convention this project uses (cmd/melon/main.go), but a main.go at the
-- module root is also picked up. A module with several commands yields a run
-- task per command.
--
-- Tags: 'build', 'build_all', 'run', 'test'

local shared = require 'overseer.shared'

---Cache dir for built binaries, so nothing lands in the repo (this module has
---no .gitignore, so a stray ./melon would show up as untracked noise).
---@param name string
---@return string
local function out_path(name)
  local dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'overseer')
  vim.fn.mkdir(dir, 'p')
  return vim.fs.joinpath(dir, name)
end

---Main packages to build or run, as go package patterns.
---`./cmd/melon` for cmd/melon/main.go; `.` for a root main.go.
---@param root string
---@return string[] patterns, entry_name
local function main_packages(root)
  local patterns, name = {}, nil

  for _, main_go in ipairs(vim.fn.glob(root .. '/cmd/*/main.go', false, true)) do
    local dir = vim.fs.dirname(main_go)
    patterns[#patterns + 1] = './cmd/' .. vim.fs.basename(dir)
  end

  if vim.uv.fs_stat(root .. '/main.go') then
    table.insert(patterns, 1, '.')
    name = vim.fs.basename(root)
  else
    -- Prefer sorting so the first command is stable across runs.
    table.sort(patterns)
  end

  if not name then
    name = patterns[1] and vim.fs.basename(patterns[1]) or 'melon'
  end

  return patterns, name
end

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return shared.find('go.mod', opts.dir)
  end,

  generator = function(opts)
    local gomod = shared.find('go.mod', opts.dir)
    if not gomod then
      return 'No go.mod found'
    end
    if vim.fn.executable 'go' == 0 then
      return 'Command "go" not found'
    end

    local root = vim.fs.dirname(gomod)
    local entry, name = main_packages(root)

    local function task(tname, tags, cmd, components, params)
      return {
        name = tname,
        tags = tags,
        params = params,
        builder = function(p)
          local argv = vim.deepcopy(cmd)
          if p and p.args then
            vim.list_extend(argv, p.args)
          end
          return { cmd = argv, cwd = root, components = components }
        end,
      }
    end

    local tasks = {
      -- Compile-check the whole module. Fast, and no artifact to clean up.
      task('Go: build', { 'build' }, { 'go', 'build', './...' }, shared.build_components),
      task('Go: test', { 'test' }, { 'go', 'test', './...' }, shared.build_components),
    }

    if #entry > 0 then
      table.insert(
        tasks,
        task(
          'Go: build binary',
          { 'build_all' },
          { 'go', 'build', '-o', out_path(name), entry[1] },
          shared.build_components
        )
      )
      -- Args are optional, so this does not prompt unless you want it to.
      table.insert(
        tasks,
        task(
          'Go: run' .. (entry[1] ~= '.' and (' ' .. entry[1]) or ''),
          { 'run' },
          { 'go', 'run', entry[1] },
          shared.run_components,
          {
            args = {
              type = 'list',
              subtype = { type = 'string' },
              delimiter = ' ',
              desc = 'Arguments for the program',
              optional = true,
            },
          }
        )
      )
    end

    return tasks
  end,
}