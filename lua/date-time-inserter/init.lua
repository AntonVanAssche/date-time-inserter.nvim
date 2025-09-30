local config = require("date-time-inserter.config")
local date = require("date-time-inserter.date")
local time = require("date-time-inserter.time")

local M = {}

M.setup = function(opts)
  config.setup(opts)
end

M.insert_date = function(override_format, offset)
  local _date = date.setup(override_format, offset)
  vim.api.nvim_put({ _date }, "c", true, true)
end

M.insert_time = function(override_format, offset)
  local _time = time.setup(override_format, offset)
  vim.api.nvim_put({ _time }, "c", true, true)
end

M.insert_date_time = function()
  local d = date.setup()
  local t = time.setup()
  local str = d .. config.config.date_time_separator .. t
  vim.api.nvim_put({ str }, "c", true, true)
end

return M
