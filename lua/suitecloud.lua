local M = {}

local bufnr = vim.api.nvim_create_buf(false, true)

local function on_event(_, lines, event)
  if (event == 'stdout') then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
end

local function on_exit() end

function M.run(cmd)
  local opts = {
    on_stdout = on_event,
    on_exit = on_exit,
    stdout_buffered = true,
  }

  if (cmd == 'deploy') then
    vim.fn.jobstart('suitecloud project:deploy', opts)
  elseif (cmd == 'preview') then
    vim.fn.jobstart('suitecloud project:deploy --dryrun', opts)
  else
    vim.notify('Invalid Suitecloud Command: ' .. cmd, vim.log.levels.ERROR)
    return
  end
  local width = vim.o.columns / 2
  local height = vim.o.lines / 2
  local row = height / 2
  local col = width / 2
  vim.api.nvim_open_win(bufnr, true,
    {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'double',
      title = 'Suitecloud <' .. cmd .. '>'
    }
  );
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', [[<CMD>quit<CR>]], {})
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'Suitecloud operation in progress...' })
end

M.commands = { 'deploy', 'preview' }

return M
