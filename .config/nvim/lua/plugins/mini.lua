---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    lazy = false,
    config = function()
      local gen_ai_spec = require('mini.extra').gen_ai_spec

      require('mini.ai').setup {
        n_lines = 100,
        custom_textobjects = {
          e = gen_ai_spec.buffer()
        },
      }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      require('mini.pairs').setup()

      require('mini.splitjoin').setup({
        mappings = {
          toggle = 'gs'
        }
      })
    end,
  },
}
