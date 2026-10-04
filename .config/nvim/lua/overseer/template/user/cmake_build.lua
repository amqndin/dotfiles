---@module 'overseer.template.user'
return {
  name = 'CMake: build current file',
  condition = {
    function()
      return vim.fn.filereadable 'CMakeLists.txt' == 1 and vim.bo.filetype == 'cpp'
    end,
  },
  builder = function()
    -- CMake target names match the source stems: problem02.cpp -> problem02
    local target = vim.fn.expand '%:p:t:r'
    return {
      cmd = { 'cmake', '--build', 'build', '--target', target },
      components = {
        { 'on_output_quickfix', open_on_match = true },
        { 'on_result_diagnostics', set_diagnostics = true },
        'default',
      },
    }
  end,
}