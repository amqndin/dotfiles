local M = {}

local state = {
  buf = -1,
  win = -1,
}

function M.toggle_floating()
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
        vim.api.nvim_chan_send(vim.bo[state.buf].channel, "clear\n")
      end
    end
    vim.cmd 'startinsert'
  end
end

function M.toggle_normal_mode()
  if vim.bo.buftype == 'terminal' then
    if vim.api.nvim_get_mode().mode == 't' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 'n', true)
    else
      vim.cmd 'startinsert'
    end
  end
end

return M
