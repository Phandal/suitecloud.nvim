local util = require('suitecloud.util')
local api = require('suitecloud.api')
local win = require('suitecloud.window')
local M = {}

---@type integer
local bufnr = -1

---@type integer
local winnr = -1

---@type string
local executable_name = 'suitecloud'

local function try_create_buffer()
  if (not vim.api.nvim_buf_is_valid(bufnr)) then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', [[<CMD>quit<CR>]], {})
  end
end

function M.run(cmd)
  if (not util.executable_exists(executable_name)) then
    vim.notify(executable_name .. ' executable not found in PATH', vim.log.levels.ERROR);
    return
  end

  if (cmd == 'focus') then
    return api.focus(winnr)
  end

  try_create_buffer()
  if (cmd == 'deploy') then
    winnr = win.try_open_win('deploy', winnr, bufnr)
    return api.deploy(executable_name, bufnr)
  elseif (cmd == 'preview') then
    winnr = win.try_open_win(cmd, winnr, bufnr)
    return api.preview(executable_name, bufnr)
  else
    return 'invalid Suitecloud Command: ' .. cmd
  end
end

M.commands = { 'deploy', 'preview', 'focus' }

return M
