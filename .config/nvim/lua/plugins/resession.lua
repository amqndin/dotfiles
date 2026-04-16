return {
  'stevearc/resession.nvim',
  opts = {
    autosave = {
      enabled = true,
      interval = 60,
      notify = false,
    },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)

    local function get_tab_name()
      local path = vim.fn.getcwd(-1, vim.api.nvim_get_current_tabpage())
      return vim.fn.fnamemodify(path, ":t")
    end

    vim.keymap.set('n', '<leader>ss', function() resession.save_tab(get_tab_name(), { notify = true }) end, { desc = 'Save session' })
    vim.keymap.set('n', '<leader>sf', resession.load, { desc = 'Select a session to load' })
    vim.keymap.set('n', '<leader>sl', function() resession.load 'last' end, { desc = 'Load last session' })
    vim.keymap.set('n', '<leader>sd', resession.delete, { desc = 'Select a session to delete' })

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'VimLeavePre', 'TabClosed' }, {
      callback = function()
        resession.save_tab(get_tab_name(), { notify = false })
        resession.save('last', { notify = false })
      end,
    })

    vim.api.nvim_create_autocmd('StdinReadPre', {
      callback = function()
        vim.g.using_stdin = true
      end,
    })
  end,
}
