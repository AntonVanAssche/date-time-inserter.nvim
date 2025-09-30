local M = {}
local cmds = {
  {
    name = "InsertDate",
    desc = "Insert the current date.",
    func = function(opts)
      local format_arg, offset

      if #opts.fargs == 0 then
        format_arg, offset = nil, nil
      elseif opts.fargs[1]:match("^[+-]") then
        format_arg, offset = nil, opts.fargs[1]
      else
        format_arg = opts.fargs[1]
        offset = opts.fargs[2]
      end

      require("date-time-inserter").insert_date(format_arg, offset)
    end,
    opts = {
      nargs = "*",
    },
  },
  {
    name = "InsertTime",
    desc = "Insert the current time.",
    func = function(opts)
      local format_arg, offset

      if #opts.fargs == 0 then
        format_arg, offset = nil, nil
      else
        local fargs = opts.fargs
        local split_index = nil

        for i, arg in ipairs(fargs) do
          if arg:match("^[+-]") then
            split_index = i
            break
          end
        end

        if split_index then
          if split_index > 1 then
            format_arg = table.concat(vim.list_slice(fargs, 1, split_index - 1), " ")
          else
            format_arg = nil
          end
          offset = table.concat(vim.list_slice(fargs, split_index), " ")
        else
          format_arg = table.concat(fargs, " ")
          offset = nil
        end
      end

      require("date-time-inserter").insert_time(format_arg, offset)
    end,
    opts = {
      nargs = "*",
    },
  },
  {
    name = "InsertDateTime",
    desc = "Insert the current date and time.",
    func = function()
      require("date-time-inserter").insert_date_time()
    end,
    opts = {
      nargs = 0,
    },
  },
}

local _create_command = function(name, func, opts)
  vim.api.nvim_create_user_command(name, func, opts)
end

-- Should only be called from plugin directory.
M.setup = function()
  for _, cmd in ipairs(cmds) do
    _create_command(cmd.name, cmd.func, cmd.opts)
  end
end

return M
