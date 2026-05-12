local default_cols = vim.o.columns

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    default_cols = vim.o.columns
    vim.o.columns = 100
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.md",
  callback = function()
    vim.o.columns = default_cols
  end,
})

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
