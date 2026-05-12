local md_group = vim.api.nvim_create_augroup("MarkdownConfig", { clear = true })
local default_cols

vim.api.nvim_create_autocmd("VimEnter", {
  group = md_group,
  callback = function()
    default_cols = vim.o.columns
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = md_group,
  pattern = "*.md",
  callback = function()
    vim.o.columns = 100
    vim.opt_local.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = md_group,
  pattern = "*.md",
  callback = function()
    if default_cols then
      vim.o.columns = default_cols
    end
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
