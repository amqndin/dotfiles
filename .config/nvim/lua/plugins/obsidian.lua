return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  event = 'FileType',
  ft = 'markdown',
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = 'personal',
        path = '~/src/github/amqndin/notes/',
      },
      {
        name = 'funcfusion',
        path = '~/src/github/funcfusion/obsidian_vault/',
      },
    },
    frontmatter = { enabled = false },
    picker = {
      name = 'snacks.pick'
    }
  },
  keys = {
    { '<leader>nb', ':Obsidian backlinks<cr>', desc = 'obsidian [b]acklinks' },
    { '<leader>nf', ':Obsidian follow_link<cr>', desc = 'obsidian [f]ollow link' },
    { '<leader>nn', ':Obsidian new<cr>', desc = 'obsidian [n]ew' },
    { '<leader>ns', ':Obsidian search<cr>', desc = 'obsidian [s]earch' },
    { '<leader>no', ':Obsidian quick_switch<cr>', desc = 'obsidian [o]pen quickswitch' },
    { '<leader>nO', ':Obsidian<cr>', desc = 'obsidian [O]pen in app' },
  },
  -- config = function(_, opts)
  --   require('obsidian').setup(opts)
  --
  --   vim.api.nvim_create_autocmd('FileType', {
  --     pattern = 'markdown',
  --     callback = function()
  --       local is_obsidian = vim.fs.find('.obsidian', { 
  --         upward = true, 
  --         stop = vim.uv.os_homedir(),
  --         path = vim.fn.expand('%:p:h') 
  --       })[1]
  --
  --       if is_obsidian then
  --         vim.opt_local.columns = 100
  --       end
  --     end,
  --   })
  -- end
}
