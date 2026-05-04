-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
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

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>', { desc = 'Write buffer' })
vim.keymap.set('n', '<Leader>d', '<Cmd>quit<CR>', { desc = 'Quit buffer' })

-- convenience
vim.keymap.set('v', 'g/', [[/\%V]], { desc = 'Search in selection' })
vim.keymap.set({ 'i', 't', 'c' }, '<C-BS>', '<C-w>')

local state = {
  buf = -1,
  win = -1,
}

local function toggle_terminal()
  if not vim.api.nvim_buf_is_valid(state.buf) then 
    state.buf = vim.api.nvim_create_buf(false, true) 
  end

  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
  else
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    state.win = vim.api.nvim_open_win(state.buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      col = math.floor((vim.o.columns - width) / 2),
      row = math.floor((vim.o.lines - height) / 2),
      style = 'minimal',
      border = 'rounded',
    })

    if vim.bo[state.buf].buftype ~= 'terminal' then
      vim.cmd.term()

      local venv_path = vim.fn.getcwd() .. "/.venv/bin/activate.fish"
      if vim.fn.filereadable(venv_path) == 1 then
        local cmd = "source " .. venv_path .. "\n"
        vim.api.nvim_chan_send(vim.bo[state.buf].channel, cmd)
      end
    end
    vim.cmd 'startinsert'
  end
end

vim.keymap.set({ 'n', 't' }, '<A-j>', toggle_terminal)

local function toggle_terminal_mode()
  if vim.bo.buftype == 'terminal' then
    if vim.api.nvim_get_mode().mode == 't' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 'n', true)
    else
      vim.cmd 'startinsert'
    end
  end
end

vim.keymap.set({ 'n', 't' }, '<A-k>', toggle_terminal_mode)

-- vim: ts=2 sts=2 sw=2 et
