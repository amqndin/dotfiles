-- Cargo projects.
--
-- Tags: 'build', 'build_all', 'run'

local shared = require 'overseer.shared'

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return shared.find('Cargo.toml', opts.dir)
  end,

  generator = function(opts)
    local manifest = shared.find('Cargo.toml', opts.dir)
    if not manifest then
      return 'No Cargo.toml found'
    end
    if vim.fn.executable 'cargo' == 0 then
      return 'Command "cargo" not found'
    end

    local root = vim.fs.dirname(manifest)

    local function task(name, tags, cmd, components)
      return {
        name = name,
        tags = tags,
        builder = function()
          return { cmd = cmd, cwd = root, components = components }
        end,
      }
    end

    return {
      task('Cargo: build', { 'build' }, { 'cargo', 'build' }, shared.build_components),
      task('Cargo: build all', { 'build_all' }, { 'cargo', 'build' }, shared.build_components),
      task('Cargo: run', { 'run' }, { 'cargo', 'run' }, shared.run_components),
    }
  end,
}