local M = {}
local cmds = {
  {
    name = "InsertDate",
    desc = "Insert the current date.",
    func = "require('date-time-inserter').insert_date()",
    opts = {
      nargs = 0,
    },
  },
  {
    name = "InsertTime",
    desc = "Insert the current time.",
    func = "require('date-time-inserter').insert_time()",
    opts = {
      nargs = 0,
    },
  },
  {
    name = "InsertDateTime",
    desc = "Insert the current date and time.",
    func = "require('date-time-inserter').insert_date_time()",
    opts = {
      nargs = 0,
    },
  },
}

local _create_command = function(name, func, opts)
  vim.api.nvim_create_user_command(name, "lua " .. func, opts)
end

-- Should only be called from plugin directory.
M.setup = function()
  for _, cmd in ipairs(cmds) do
    _create_command(cmd.name, cmd.func, cmd.opts)
  end
end

return M
