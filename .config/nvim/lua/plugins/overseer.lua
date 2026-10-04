---@module 'lazy'
---@type LazySpec
return {
  {
    -- Task runner: build and run CMake targets from inside Neovim
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle' },
    keys = {
      {
        '<leader>rb',
        function()
          require('overseer').run_task { name = 'CMake: build current file', first = true }
        end,
        desc = '[B]uild current file',
      },
      {
        '<leader>rr',
        function()
          require('overseer').run_task { name = 'CMake: build and run', first = true }
        end,
        desc = '[R]un current file',
      },
      {
        '<leader>ro',
        function()
          require('overseer').toggle()
        end,
        desc = 'Toggle overseer [O]utput',
      },
    },
    ---@module 'overseer'
    ---@type overseer.Config
    opts = {},
  },
}
-- vim: ts=2 sts=2 sw=2 et