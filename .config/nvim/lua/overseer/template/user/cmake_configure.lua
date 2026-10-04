---@module 'overseer.template.user'
return {
  name = 'CMake: configure',
  condition = {
    function()
      return vim.fn.filereadable 'CMakeLists.txt' == 1
    end,
  },
  builder = function()
    return {
      cmd = { 'cmake', '-B', 'build', '-D', 'CMAKE_BUILD_TYPE=Release' },
      components = { { 'on_output_quickfix', open_on_match = true }, 'default' },
    }
  end,
}