---@module 'lazy'
---@type LazySpec

-- Language-agnostic. Tasks are selected by tag, not by name, so this file
-- never has to know which languages exist. Each language/build-system module
-- under lua/overseer/template/user/lang/ yields tasks carrying these tags, and
-- the first module whose condition matches the current project wins.
--
--   'configure'  set the project up
--   'build'      build just what the current buffer needs
--   'build_all'  build everything the project builds
--   'run'        run it, with output visible
--
-- Adding a language means adding one file in lang/. Nothing here changes.
local function tag(tag_name)
  require('overseer').run_task { tags = { tag_name }, first = true }
end

return {
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle' },
    init = function()
      -- Ad-hoc commands as tracked tasks: :OS pytest -x
      vim.cmd.cnoreabbrev 'OS OverseerShell'
    end,
    keys = {
      { '<leader>rb', function() tag 'build' end, desc = '[B]uild current file' },
      { '<leader>ra', function() tag 'build_all' end, desc = 'Build [A]ll targets' },
      { '<leader>rr', function() tag 'run' end, desc = '[R]un current file' },
      { '<leader>rc', function() tag 'configure' end, desc = '[C]onfigure project' },
      {
        '<leader>ro',
        function()
          require('overseer').toggle()
        end,
        desc = 'Toggle overseer [T]ask list',
      },
    },
    ---@module 'overseer'
    ---@type overseer.Config
    opts = {
      task_list = {
        bindings = {
          -- These normally move focus between splits. Inside the task list
          -- they just fight with scrolling, so turn them off.
          ['<C-l>'] = false,
          ['<C-h>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et