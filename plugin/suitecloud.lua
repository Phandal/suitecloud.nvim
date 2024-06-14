vim.api.nvim_create_user_command('Suitecloud', function(opts)
    local err_msg = require('suitecloud').run(unpack(opts.fargs))
    if (err_msg) then
      vim.notify('[SuiteCloud] ' .. err_msg, vim.log.levels.ERROR)
    end
  end,
  {
    nargs = '*',
    desc = 'Wrapper around the suitecloud cli provided by Oracle',
    complete = function()
      return require('suitecloud').commands
    end,
  }
)
