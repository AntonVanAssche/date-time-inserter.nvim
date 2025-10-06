local config = require("date-time-inserter.config")

local M = {}

M.parse_args = function(fargs)
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

  if format_arg and config.config.presets[format_arg] then
    format_arg = config.config.presets[format_arg]
  end

  return format_arg, offset
end

M.apply_offset_time = function(base_time, offset_str)
  local seconds = 0

  for sign, num, unit in offset_str:gmatch("([+-])(%d+)([HMS])") do
    local n = tonumber(num)

    if unit == "H" then
      n = n * 3600
    elseif unit == "M" then
      n = n * 60
    elseif unit == "S" then
      n = n
    end
    if sign == "-" then
      n = -n
    end

    seconds = seconds + n
  end

  return base_time + seconds
end

M.apply_offset_date = function(base_time, offset_str)
  base_time = tonumber(base_time) or os.time()
  local date_table = os.date("*t", base_time)

  for sign, num, unit in offset_str:gmatch("([+-])(%d+)([ymd])") do
    local n = tonumber(num)

    if sign == "-" then
      n = -n
    end

    if unit == "y" then
      date_table.year = date_table.year + n
    elseif unit == "m" then
      date_table.month = date_table.month + n
    elseif unit == "d" then
      date_table.day = date_table.day + n
    end
  end

  return os.time(date_table)
end

return M
