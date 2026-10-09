-- CMake projects: any directory containing a CMakeLists.txt.
--
-- Follows the pattern the built-in providers use (see overseer's
-- template/make.lua): no `condition`, because condition only understands
-- `filetype` and `dir` -- it cannot ask "does an ancestor hold this file".
-- Instead the generator reports why it has nothing, and cache_key keys the
-- results on the file that was found.
--
-- Two rules worth keeping:
--   * every yielded template needs a `name`; without one it is silently
--     dropped by validate_template_definition and never matches a tag search
--   * select by tag from the plugin spec, never by name, so this file can be
--     renamed freely
--
-- Tags: 'configure', 'build', 'build_all', 'run'

local shared = require 'overseer.shared'

---@type overseer.TemplateFileProvider
return {
  cache_key = function(opts)
    return shared.find('CMakeLists.txt', opts.dir)
  end,

  generator = function(opts)
    local cmakelists = shared.find('CMakeLists.txt', opts.dir)
    if not cmakelists then
      return 'No CMakeLists.txt found'
    end
    if vim.fn.executable 'cmake' == 0 then
      return 'Command "cmake" not found'
    end

    local root = vim.fs.dirname(cmakelists)
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
      task(
        'CMake: configure',
        { 'configure' },
        { 'cmake', '-B', 'build', '-D', 'CMAKE_BUILD_TYPE=Release' },
        shared.setup_components
      ),
      -- Target names conventionally match the source file stem.
      task(
        'CMake: build current target',
        { 'build' },
        { 'cmake', '--build', 'build', '--target', stem },
        shared.build_components
      ),
      task('CMake: build all targets', { 'build_all' }, { 'cmake', '--build', 'build' }, shared.build_components),
      {
        name = 'CMake: build and run current target',
        tags = { 'run' },
        builder = function()
          return {
            cmd = { 'cmake', '--build', 'build', '--target', stem },
            cwd = root,
            components = shared.chain_run(shared.build_components, {
              name = 'run ' .. stem,
              cmd = { 'build/' .. stem },
              cwd = root,
              components = shared.run_components,
            }),
          }
        end,
      },
    }
  end,
}