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
    vim.keymap.set('n', '<leader>sS', resession.save)
    vim.keymap.set('n', '<leader>sf', resession.load)
    vim.keymap.set('n', '<leader>sl', function() resession.load 'last' end)
    vim.keymap.set('n', '<leader>sd', resession.delete)

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
