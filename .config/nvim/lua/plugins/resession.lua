return {
  'stevearc/resession.nvim',
  opts = {
    autosave = { enabled = true, interval = 60, notify = false },
    options = { "binary", "bufhidden", "buflisted", "buftype", "filetype", "modifiable", "readonly", "syntax" },
  },
  config = function(_, opts)
    local resession = require 'resession'
    resession.setup(opts)

    local function get_tab_name()
      local path = vim.fn.getcwd()
      if not path or path == "" then return nil end
      return vim.fn.fnamemodify(path, ":t")
    end

    vim.keymap.set('n', '<leader>ss', function()
      local name = get_tab_name()
      if name then resession.save_tab(name) end
    end)
    vim.keymap.set('n', '<leader>sf', resession.load)
    vim.keymap.set('n', '<leader>sl', function() resession.load 'last' end)
    vim.keymap.set('n', '<leader>sd', resession.delete)

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'VimLeavePre', 'TabLeave' }, {
      callback = function()
        if vim.g.using_stdin then return end
        
        local name = get_tab_name()
        if not name then return end

        local ei = vim.opt.eventignore:get()
        vim.opt.eventignore:append 'WinResized'
        
        -- Wrap save in pcall to ignore snacks/layout death
        pcall(resession.save_tab, name, { notify = false })
        pcall(resession.save, 'last', { notify = false })
        
        vim.opt.eventignore = ei
      end,
    })
  end,
}
