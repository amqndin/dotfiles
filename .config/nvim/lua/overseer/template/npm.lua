-- Node projects. npm script names are project-defined, so these assume the
-- conventional `build` and `start` scripts exist.
--
-- Tags: 'configure', 'build', 'build_all', 'run'

local shared = require 'overseer.shared'

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return shared.find('package.json', opts.dir)
  end,

  generator = function(opts)
    local manifest = shared.find('package.json', opts.dir)
    if not manifest then
      return 'No package.json found'
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
      task('npm: install', { 'configure' }, { 'npm', 'install' }, shared.setup_components),
      task('npm: build', { 'build', 'build_all' }, { 'npm', 'run', 'build' }, shared.build_components),
      task('npm: start', { 'run' }, { 'npm', 'start' }, shared.run_components),
    }
  end,
}