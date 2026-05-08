return {
  'stevearc/resession.nvim',
  event = 'VimEnter',
  opts = {
    autosave = { enabled = true, interval = 60, notify = false },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)

    vim.keymap.set('n', '<leader>ss', function()
      local path = vim.fn.getcwd()
      local name = vim.fn.fnamemodify(path, ":t")
      if name then resession.save(name) end
    end)
    vim.keymap.set('n', '<leader>sS', resession.save, { desc = 'Save session'})
    vim.keymap.set('n', '<leader>sl', resession.load, { desc = 'Load session' })
    vim.keymap.set('n', '<leader>sr', function() resession.load 'last' end, { desc = 'Restore session' })
    vim.keymap.set('n', '<leader>sd', resession.delete, { desc = 'Delete session' })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        local path = vim.fn.getcwd()
        local name = vim.fn.fnamemodify(path, ":t")
        if name then
          resession.save(name)
          resession.save('last')
        end
      end,
    })
  end,
}
