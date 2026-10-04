---@module 'overseer.template.user'
return {
  name = 'CMake: build and run',
  condition = {
    function()
      return vim.fn.filereadable 'CMakeLists.txt' == 1 and vim.bo.filetype == 'cpp'
    end,
  },
  builder = function()
    local target = vim.fn.expand '%:p:t:r'
    return {
      cmd = { 'cmake', '--build', 'build', '--target', target },
      components = {
        { 'on_output_quickfix', open_on_match = true },
        { 'on_result_diagnostics', set_diagnostics = true },
        {
          'run_after',
          statuses = { 'SUCCESS' },
          tasks = {
            {
              name = 'run ' .. target,
              cmd = { './build/' .. target },
              components = { { 'on_output_quickfix', open_on_match = true }, 'default' },
            },
          },
        },
        'default',
      },
    }
  end,
}