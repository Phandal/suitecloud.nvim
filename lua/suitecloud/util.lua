local M = {}

--- Checks if the provided executable exists
--- @param exec string The name of the executable
--- @return integer
function M.executable_exists(exec)
  return vim.fn.executable(exec)
end

return M
