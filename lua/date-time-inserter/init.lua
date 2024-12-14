local config = require("date-time-inserter.config")
local date = require("date-time-inserter.date")
local time = require("date-time-inserter.time")

local M = {}

M.setup = function(opts)
  config.setup(opts)
end

M.insert_date = function()
  local _date = date.setup(config.config.date_format, config.config.date_separator)
  vim.api.nvim_put({ _date }, "c", true, true)
end

M.insert_time = function()
  local _time = time.setup(config.config.time_format, config.config.show_seconds)
  vim.api.nvim_put({ _time }, "c", true, true)
end

M.insert_date_time = function()
  local _date = date.setup(config.config.date_format, config.config.date_separator)
  local _time = time.setup(config.config.time_format, config.config.show_seconds)
  local str = _date .. config.config.date_time_separator .. _time
  vim.api.nvim_put({ str }, "c", true, true)
end

return M
