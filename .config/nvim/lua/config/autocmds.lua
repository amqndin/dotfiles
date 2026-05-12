local md_group = vim.api.nvim_create_augroup("MarkdownConfig", { clear = true })
local MD_WIDTH_LIMIT = 100
local real_terminal_width

vim.api.nvim_create_autocmd({"VimEnter", "VimResized"}, {
  group = md_group,
  callback = function()
    vim.defer_fn(function()
      local not_currently_capped = (vim.o.columns ~= MD_WIDTH_LIMIT)
      if not_currently_capped then
        real_terminal_width = vim.o.columns
        vim.notify("width captured: " .. tostring(real_terminal_width))
      end
    end, 50)
  end,
})

vim.api.nvim_create_autocmd({"BufEnter", "VimResized"}, {
  group = md_group,
  pattern = "*.md",
  callback = function()
    vim.defer_fn(function()
      local screen_is_wide = (real_terminal_width > MD_WIDTH_LIMIT)

      if real_terminal_width and screen_is_wide then
        vim.o.columns = MD_WIDTH_LIMIT
      end
      vim.opt_local.conceallevel = 2
    end, 50)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = md_group,
  pattern = "*.md",
  callback = function()
    if real_terminal_width then
      vim.o.columns = real_terminal_width
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
