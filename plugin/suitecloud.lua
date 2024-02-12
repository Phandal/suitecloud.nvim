vim.api.nvim_create_user_command('Suitecloud', function(opts)
    require('suitecloud').run(unpack(opts.fargs))
  end,
  {
    nargs = '*',
    desc = 'Wrapper around the suitecloud cli provided by Oracle',
    complete = function()
      return require('suitecloud').commands
    end,
  }
)
