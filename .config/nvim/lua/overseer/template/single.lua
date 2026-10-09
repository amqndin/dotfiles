-- Fallback for directories with no build system: no CMakeLists.txt, Makefile,
-- Cargo.toml, package.json or go.mod. Compiles the current buffer directly
-- using a per-filetype command, so <leader>rb still does something sensible in
-- a bare repo or a scratch file.
--
-- This is the only 'build' provider that does not key off a build file, so it
-- defers to the real ones: if any of those files exists, it reports that and
-- yields nothing.
--
-- Tags: 'build', 'build_all', 'run'

local shared = require 'overseer.shared'

---Build systems that supersede this fallback.
local SUPERSEDED = { 'CMakeLists.txt', 'Makefile', 'makefile', 'Cargo.toml', 'package.json', 'go.mod' }

---Filetype -> argv builder. Receives source path and output path.
---@type table<string, fun(src: string, out: string): string[]>
local RECIPES = {
  c = function(src, out)
    return { 'cc', '-Wall', '-Wextra', '-g', '-o', out, src }
  end,
  cpp = function(src, out)
    return { 'c++', '-std=c++20', '-Wall', '-Wextra', '-g', '-o', out, src }
  end,
  rust = function(src, out)
    return { 'rustc', '-g', '-o', out, src }
  end,
  go = function(src, out)
    return { 'go', 'build', '-o', out, src }
  end,
  python = function(src)
    return { 'python3', '-m', 'py_compile', src }
  end,
  lua = function(src)
    return { 'luac', '-p', src }
  end,
  sh = function(src)
    return { 'sh', '-n', src }
  end,
  javascript = function(src)
    return { 'node', '--check', src }
  end,
}

---Stable output path outside the project, so 'run' can find the artifact
---without writing build junk into the repo.
---@param stem string
---@return string
local function out_path(stem)
  local dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'overseer')
  vim.fn.mkdir(dir, 'p')
  return vim.fs.joinpath(dir, stem)
end

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    -- Varies per file, since the recipe depends on filetype and the stem.
    return table.concat({ vim.bo.filetype, vim.fn.expand '%:p', opts.dir }, ':')
  end,

  generator = function(opts)
    -- Note: returning nil here would leave overseer waiting on the callback
    -- until template_timeout_ms and log a timeout. Always return a table or a
    -- message string.
    for _, marker in ipairs(SUPERSEDED) do
      if shared.find(marker, opts.dir) then
        return string.format('%s found, handled by that build system', marker)
      end
    end

    local recipe = RECIPES[vim.bo.filetype]
    if not recipe then
      return string.format("No compile recipe for filetype '%s'", vim.bo.filetype)
    end

    local src = vim.fn.expand '%:p'
    local out = out_path(shared.stem())
    local cmd = recipe(src, out)

    local function task(name, tags, components)
      return {
        name = name,
        tags = tags,
        builder = function()
          return { cmd = cmd, cwd = opts.dir, components = components }
        end,
      }
    end

    return {
      task('Single file: compile ' .. vim.bo.filetype, { 'build', 'build_all' }, shared.build_components),
      {
        name = 'Single file: run ' .. vim.bo.filetype,
        tags = { 'run' },
        builder = function()
          return {
            cmd = { out },
            cwd = opts.dir,
            components = shared.run_components,
          }
        end,
      },
    }
  end,
}