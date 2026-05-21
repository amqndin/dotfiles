vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- leader
vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>', { desc = 'Write buffer' })
vim.keymap.set('n', '<Leader>d', '<Cmd>quit<CR>', { desc = 'Quit buffer' })

-- buffers
vim.keymap.set('n', '<Leader>bd', '<Cmd>bd<CR>')
vim.keymap.set('n', '<Leader>bn', '<Cmd>bn<CR>')
vim.keymap.set('n', '<Leader>bp', '<Cmd>bp<CR>')
vim.keymap.set('n', '<Leader>bo', '<Cmd>%bd|e#<CR>')

-- convenience
vim.keymap.set('v', 'g/', [[/\%V]], { desc = 'Search in selection' })
vim.keymap.set({ 'i', 't', 'c' }, '<C-BS>', '<C-w>')
vim.keymap.set('c', '<C-j>', '<C-n>', { remap = true })
vim.keymap.set('c', '<C-k>', '<C-p>', { remap = true })
vim.keymap.set('n', '[t', '<Cmd>tabp<CR>')
vim.keymap.set('n', ']t', '<Cmd>tabn<CR>')

-- visual lines
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '$', 'g$')
vim.keymap.set('n', '0', 'g0')
vim.keymap.set('n', '^', 'g^')

-- terminal
local terminal = require('config.terminal')
vim.keymap.set({ 'n', 't' }, '<A-j>', terminal.toggle_floating)
vim.keymap.set({ 'n', 't' }, '<A-k>', terminal.toggle_normal_mode)

-- vim: ts=2 sts=2 sw=2 et
