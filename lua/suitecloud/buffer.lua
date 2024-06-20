local M = {}

--- Trys to create a buffer if it does not already exist.
--- Returns the buffer id of the suitecloud buffer
--- @param bufnr number Buffer ID for the suitecloud output window
--- @return number
function M.try_create_buffer(bufnr)
  if (not vim.api.nvim_buf_is_valid(bufnr)) then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', [[<CMD>quit<CR>]], {})
    vim.api.nvim_set_option_value('filetype', 'SuiteCloud', { buf = bufnr })
  end
  return bufnr
end

--- Sets the title of the suitecloud buffer
--- @param bufnr number The buffer id of the suitecloud output window
--- @param title string The title of the buffer
function M.set_title(bufnr, title)
  assert(bufnr, 'buffer ' .. bufnr .. ' does not exist')
  vim.api.nvim_buf_set_name(bufnr, [[Suitecloud <]] .. title .. [[>]])
end

return M
