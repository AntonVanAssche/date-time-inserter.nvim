local feedback = require("date-time-inserter.ui.feedback")

local M = {}

function M.parse_args(fargs, presets)
  if #fargs == 0 then
    return nil, nil
  end

  local fmt_parts, offset_parts = {}, {}

  for _, arg in ipairs(fargs) do
    if arg:match("^[+-]") then
      table.insert(offset_parts, arg)
    else
      table.insert(fmt_parts, arg)
    end
  end

  local fmt = #fmt_parts > 0 and table.concat(fmt_parts, " ") or nil
  local offset = #offset_parts > 0 and table.concat(offset_parts, " ") or nil

  if fmt and presets then
    if presets[fmt] then
      fmt = presets[fmt]
    else
      feedback.error(("Unknown date/time preset: '%s'"):format(fmt))
      fmt = nil
    end
  end

  return fmt, offset
end

function M.apply_offset(base_time, offset_str)
  local date_table = os.date("*t", base_time)
  local seconds = 0

  for sign, num, unit in offset_str:gmatch("([+-])(%d+)([ymdHMS])") do
    local n = tonumber(num) * (sign == "-" and -1 or 1)
    if unit == "y" then
      date_table.year = date_table.year + n
    elseif unit == "m" then
      date_table.month = date_table.month + n
    elseif unit == "d" then
      date_table.day = date_table.day + n
    elseif unit == "H" then
      seconds = seconds + (n * 3600)
    elseif unit == "M" then
      seconds = seconds + (n * 60)
    elseif unit == "S" then
      seconds = seconds + n
    end
  end

  return (os.time(date_table)) + seconds
end

return M
