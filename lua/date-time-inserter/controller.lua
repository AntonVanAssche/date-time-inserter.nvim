local config = require("date-time-inserter.model.config")
local date = require("date-time-inserter.model.date")
local time = require("date-time-inserter.model.time")
local utils = require("date-time-inserter.model.utils")
local feedback = require("date-time-inserter.ui.feedback")

local M = {}

function M.insert_date(fargs)
  local fmt, offset, tz = utils.parse_args(fargs, config.values.presets)
  local output = date.get(fmt, offset, tz)
  vim.api.nvim_put({ output }, "c", true, true)
end

function M.insert_time(fargs)
  local fmt, offset, tz = utils.parse_args(fargs, config.values.presets)
  local output = time.get(fmt, offset, tz)
  vim.api.nvim_put({ output }, "c", true, true)
end

function M.insert_date_time(fargs)
  local _, _, tz = utils.parse_args(fargs, config.values.presets)
  local d = date.get(nil, nil, tz)
  local t = time.get(nil, nil, tz)
  local output = d .. config.values.date_time_separator .. t
  vim.api.nvim_put({ output }, "c", true, true)
end

function M.register_commands()
  local cmds = {
    { "InsertDate", M.insert_date, "Insert the current date.", { nargs = "*" } },
    { "InsertTime", M.insert_time, "Insert the current time.", { nargs = "*" } },
    { "InsertDateTime", M.insert_date_time, "Insert current date + time.", { nargs = "*" } },
  }

  for _, c in ipairs(cmds) do
    vim.api.nvim_create_user_command(c[1], function(opts)
      local ok, err = pcall(c[2], opts.fargs)
      if not ok then
        feedback.error(err)
      end
    end, c[4])
  end
end

return M
