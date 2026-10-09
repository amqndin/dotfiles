-- Makefile projects.
--
-- Tags: 'build', 'build_all', 'run'

local shared = require 'overseer.shared'

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return shared.find('Makefile', opts.dir) or shared.find('makefile', opts.dir)
  end,

  generator = function(opts)
    local makefile = shared.find('Makefile', opts.dir) or shared.find('makefile', opts.dir)
    if not makefile then
      return 'No Makefile found'
    end
    if vim.fn.executable 'make' == 0 then
      return 'Command "make" not found'
    end

    local root = vim.fs.dirname(makefile)
    local stem = shared.stem()

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
      task('Make: build current target', { 'build' }, { 'make', stem }, shared.build_components),
      task('Make: build all targets', { 'build_all' }, { 'make' }, shared.build_components),
      {
        name = 'Make: build and run current target',
        tags = { 'run' },
        builder = function()
          return {
            cmd = { 'make', stem },
            cwd = root,
            components = shared.chain_run(shared.build_components, {
              name = 'run ' .. stem,
              cmd = { './' .. stem },
              cwd = root,
              components = shared.run_components,
            }),
          }
        end,
      },
    }
  end,
}