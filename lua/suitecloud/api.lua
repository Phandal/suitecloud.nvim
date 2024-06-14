local M = {}

--- Returns a callback function used for io with external processes
--- @param bufnr number Buffer ID used for suitecloud output window
--- @return function
local function get_on_event(bufnr)
  return function(_, lines, event)
    if (event == 'stderr') then
      vim.notify(table.concat(lines, ''), vim.log.levels.ERROR)
    end
    if (event == 'stdout') then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end
  end
end


--- Callback function used for io with external processes after exit
local function on_exit() end

--- Creates the pipes for io with external processes
--- @param bufnr number Buffer ID for the suitecloud output window
local function create_job_opts(bufnr)
  return {
    on_stdout = get_on_event(bufnr),
    on_exit = on_exit,
    stdout_buffered = true,
  }
end

--- Focus suitecloud output window
--- @param winnr number Window ID of the suitecloud output window
--- @return string
function M.focus(winnr)
  if (vim.api.nvim_win_is_valid(winnr)) then
    vim.api.nvim_set_current_win(winnr)
  else
    return 'output window not open'
  end
end

--- Preview the deployment of the project
--- @param executable_name string Name of the suitecloud executable
--- @param bufnr number Buffer ID for the suitecloud output window
--- @return string
function M.preview(executable_name, bufnr)
  local opts = create_job_opts(bufnr)
  vim.fn.jobstart(executable_name .. ' project:deploy --dryrun', opts)
  return
end

--- Deploys the project to the account
--- @param executable_name string Name of the suitecloud executable
--- @param bufnr number Buffer ID for the suitecloud output window
--- @return string
function M.deploy(executable_name, bufnr)
  local opts = create_job_opts(bufnr)
  vim.fn.jobstart(executable_name .. ' project:deploy', opts)
  return
end

return M
