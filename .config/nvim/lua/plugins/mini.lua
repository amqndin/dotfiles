---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-mini/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', opts = {}
    },
    version = false,
    -- lazy = false,
    event = 'VimEnter',
    config = function()
      local gen_ai_spec = require('mini.extra').gen_ai_spec
      local spec_treesitter = require('mini.ai').gen_spec.treesitter

      require('mini.ai').setup {
        n_lines = 100,
        custom_textobjects = {
          f = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
          o = spec_treesitter({
            a = { '@conditional.outer', '@loop.outer' },
            i = { '@conditional.inner', '@loop.inner' },
          }),
          e = gen_ai_spec.buffer(),
        },
      }


      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
      statusline.section_filename = function()
        local result = vim.fn.expand('%:t')
        if vim.bo.modified then
          result = "  " .. result
        end
        return result
      end

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
