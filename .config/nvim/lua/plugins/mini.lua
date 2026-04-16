---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.icons').setup {}
      MiniIcons.mock_nvim_web_devicons()

      require('mini.pairs').setup {}

      require('mini.splitjoin').setup {
        mappings = {
          toggle = 'gs'
        }
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
