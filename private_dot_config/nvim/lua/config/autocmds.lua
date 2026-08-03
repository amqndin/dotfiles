vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("AddDirectoryToZoxide", { clear = true }),
  desc = "Add directory to zoxide",
  callback = function(data)
    local dir = data.file
    vim.system({ "zoxide", "add", dir })
    print("Added " .. dir .. " to zoxide")
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanking',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_user_command(
    'MessagesBuffer',
    function()
      local scratch_buffer = vim.api.nvim_create_buf(false, true)
      vim.bo[scratch_buffer].filetype = 'vim'
      local messages = vim.split(vim.fn.execute('messages', 'silent'), '\n')
      vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
      vim.cmd('vertical sbuffer ' .. scratch_buffer)
      vim.opt_local.wrap = true
      vim.bo.buflisted = false
      vim.bo.bufhidden = 'wipe'
      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = scratch_buffer })
    end,
    { desc = 'My custom command description', nargs = '*' }
)
