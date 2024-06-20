local M = {}

--- Trys to open a window if it does not already exist.
--- Returns the window id of the open window
--- @param winnr number Window ID of the suitecloud output window
--- @param bufnr number Buffer ID for the suitecloud output window
--- @return number
function M.try_open_win(winnr, bufnr)
  if (not vim.api.nvim_win_is_valid(winnr)) then
    winnr = vim.api.nvim_open_win(bufnr, true,
      {
        win = -1,
        vertical = false,
        style = 'minimal',
      }
    );
  end

  vim.api.nvim_set_option_value('wrap', true, { win = winnr })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'Suitecloud operation in progress...' })

  return winnr
end

return M
