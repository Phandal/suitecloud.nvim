local M = {}

--- Checks if the provided executable exists
--- @param exec string The name of the executable
--- @return boolean
function M.executable_exists(exec)
  local is_exec = vim.fn.executable(exec)
  return (is_exec == 1)
end

return M
