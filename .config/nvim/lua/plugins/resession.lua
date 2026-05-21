return {
  'stevearc/resession.nvim',
  opts = {
    autosave = {
      enabled = true,
      interval = 60,
      notify = false
    },
    extensions = {
      quickfix = {},
    },
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
    vim.keymap.set('n', '<leader>sl', function() resession.load(nil, { reset = false }) end , { desc = 'Load session' })
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

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local launched_without_arguments = vim.fn.argc(-1) == 0
        local path = vim.fn.getcwd()

        if path == vim.fn.expand("~") then
          return
        end

        local name = vim.fn.fnamemodify(path, ":t")

        if launched_without_arguments then
          resession.load(name, { silence_errors = true })
        end
      end,
      nested = true,
    })
  end,
}
