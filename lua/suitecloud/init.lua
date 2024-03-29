local util = require('suitecloud.util')
local M = {}

---@type integer
local bufnr = vim.api.nvim_create_buf(false, true)
--
---@type integer
local winnr = -1
--
---@type string
local executable_name = 'suitecloud'

--- Callback function used for io with external processes
--- @param lines table Lines from the external process
--- @param event string Name of the event that triggered the callback
local function on_event(_, lines, event)
  if (event == 'stderr') then
    vim.notify(table.concat(lines, ''), vim.log.levels.ERROR)
  end
  if (event == 'stdout') then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end
end

local function on_exit() end

function M.run(cmd)
  if (not util.executable_exists(executable_name)) then
    vim.notify(executable_name .. ' executable not found in PATH', vim.log.levels.ERROR);
    return
  end
  local opts = {
    on_stdout = on_event,
    on_exit = on_exit,
    stdout_buffered = true,
  }

  if (cmd == 'deploy') then
    vim.fn.jobstart(executable_name .. ' project:deploy', opts)
  elseif (cmd == 'preview') then
    vim.fn.jobstart(executable_name .. ' project:deploy --dryrun', opts)
  else
    vim.notify('Invalid Suitecloud Command: ' .. cmd, vim.log.levels.ERROR)
    return
  end
  local width = math.floor(vim.o.columns / 2)
  local height = math.floor(vim.o.lines / 2)
  local row = math.floor(height / 2)
  local col = math.floor(width / 2)
  if (not vim.api.nvim_win_is_valid(winnr)) then
    winnr = vim.api.nvim_open_win(bufnr, true,
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
  else
    vim.api.nvim_win_set_config(winnr, { title = 'Suitecloud <' .. cmd .. '>' })
    vim.api.nvim_win_set_buf(winnr, bufnr)
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', [[<CMD>quit<CR>]], {})
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'Suitecloud operation in progress...' })
  vim.api.nvim_win_set_option(winnr, 'wrap', true)
end

M.commands = { 'deploy', 'preview' }

return M
