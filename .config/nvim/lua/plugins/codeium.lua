return {
  "Exafunction/codeium.nvim",
  event = "FileType",
  cmd = { "Codeium" },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = { enabled = true, map_keys = false },
    })

    local vt = require("codeium.virtual_text")
    local codeium = require("codeium")

    vim.keymap.set("i", "<M-l>", function() return vt.accept() end,
      { expr = true, silent = true, desc = "Accept Codeium completion" })
    vim.keymap.set("i", "<C-w>", function() return vt.accept_next_word() end,
      { expr = true, silent = true, desc = "Accept Codeium next word" })
    vim.keymap.set("i", "<C-e>", function() return vt.accept_next_line() end,
      { expr = true, silent = true, desc = "Accept Codeium next line" })

    vim.keymap.set("i", "<M-u>", function() vt.cycle_completions(1) end,
      { silent = true, desc = "Next Codeium completion" })
    vim.keymap.set("i", "<M-i>", function() vt.cycle_completions(-1) end,
      { silent = true, desc = "Previous Codeium completion" })
    vim.keymap.set("i", "<C-]>", function() vt.clear() end,
      { silent = true, desc = "Clear Codeium completion" })
    vim.keymap.set("i", "<M-\\>", function() vt.cycle_or_complete() end,
      { silent = true, desc = "Cycle or trigger Codeium" })
    vim.keymap.set("i", "<M-Space>", function() vt.complete() end,
      { silent = true, desc = "Force Codeium completion" })

    vim.keymap.set("n", "<leader>cc", function() codeium.chat() end,
      { desc = "Codeium Chat" })
    vim.keymap.set("n", "<leader>ct", function() codeium.toggle() end,
      { desc = "Toggle Codeium" })
  end,
}
