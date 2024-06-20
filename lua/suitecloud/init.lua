local util = require('suitecloud.util')
local api = require('suitecloud.api')
local win = require('suitecloud.window')
local buf = require('suitecloud.buffer')
local M = {}

---@type integer
local bufnr = -1

---@type integer
local winnr = -1

---@type string
local executable_name = 'suitecloud'

function M.run(cmd)
  if (not util.executable_exists(executable_name)) then
    return ([[']] .. executable_name .. [[' executable not found in PATH. Try 'npm install -g @oracle/suitecloud-cli']])
  end

  if (cmd == 'focus') then
    return api.focus(winnr)
  end

  -- All commands below require a buffer, which in turn requires a window
  bufnr = buf.try_create_buffer(bufnr)
  assert(bufnr, 'failed to create buffer')
  buf.set_title(bufnr, cmd)

  winnr = win.try_open_win(winnr, bufnr)
  assert(winnr, 'failed to create window')

  if (cmd == 'deploy') then
    return api.deploy(executable_name, bufnr)
  elseif (cmd == 'preview') then
    return api.preview(executable_name, bufnr)
  else
    vim.api.nvim_win_close(winnr, true)
    return 'invalid Suitecloud Command: ' .. cmd
  end
end

M.commands = { 'deploy', 'preview', 'focus' }

return M
