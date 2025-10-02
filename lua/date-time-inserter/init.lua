local config = require("date-time-inserter.config")
local date = require("date-time-inserter.date")
local time = require("date-time-inserter.time")

local M = {}

M.setup = function(opts)
  config.setup(opts)
end

local function parse_args(fargs)
  if #fargs == 0 then
    return nil, nil
  end

  local split_index
  for i, arg in ipairs(fargs) do
    if arg:match("^[+-]") then
      split_index = i
      break
    end
  end

  local format_arg, offset
  if split_index then
    if split_index > 1 then
      format_arg = table.concat(vim.list_slice(fargs, 1, split_index - 1), " ")
    end
    offset = table.concat(vim.list_slice(fargs, split_index), " ")
  else
    format_arg = table.concat(fargs, " ")
  end

  return format_arg, offset
end

M.format_date = function(fmt, offset)
  return date.setup(fmt, offset)
end

M.format_time = function(fmt, offset)
  return time.setup(fmt, offset)
end

M.format_date_time = function(date_fmt, date_offset, time_fmt, time_offset)
  local d = date.setup(date_fmt, date_offset)
  local t = time.setup(time_fmt, time_offset)
  return d .. config.config.date_time_separator .. t
end

M.insert_date = function(fargs)
  local fmt, offset = parse_args(fargs)
  local str = M.format_date(fmt, offset)
  vim.api.nvim_put({ str }, "c", true, true)
end

M.insert_time = function(fargs)
  local fmt, offset = parse_args(fargs)
  local str = M.format_time(fmt, offset)
  vim.api.nvim_put({ str }, "c", true, true)
end

M.insert_date_time = function()
  local str = M.format_date_time()
  vim.api.nvim_put({ str }, "c", true, true)
end

return M
