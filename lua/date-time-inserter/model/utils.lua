local feedback = require("date-time-inserter.ui.feedback")

local M = {}
local tz_abbr = {
  EST = -5, -- Eastern Standard Time
  EDT = -4, -- Eastern Daylight Time
  CST = -6, -- Central Standard Time
  CDT = -5, -- Central Daylight Time
  MST = -7, -- Mountain Standard Time
  MDT = -6, -- Mountain Daylight Time
  PST = -8, -- Pacific Standard Time
  PDT = -7, -- Pacific Daylight Time
  CET = 1, -- Central European Time
  CEST = 2, -- Central European Summer Time
  GMT = 0, -- Greenwich Mean Time
  UTC = 0, -- Universal Coordinated Time
}

function M.parse_args(fargs, presets)
  if #fargs == 0 then
    return nil, nil, nil
  end

  local fmt_parts, offset_parts, tz = {}, {}, nil

  for _, arg in ipairs(fargs) do
    if arg:match("^UTC[+-]?%d+$") or arg:match("^GMT[+-]?%d+$") or tz_abbr[arg] then
      tz = arg
    elseif arg:match("^[+-]?%d*[ymdHMS]$") then
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

  return fmt, offset, tz
end

function M.get_utc_time()
  local ok, result = pcall(os.date, "!*t")

  if not ok or type(result) ~= "table" then
    result = os.date("*t")
  end

  return os.time(result)
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

function M.apply_tz(base_time, tz)
  if not tz or tz == "" then
    return base_time
  end

  local offset_seconds = 0

  local sign, hours
  if tz:match("^UTC[+-]?%d+$") then
    sign, hours = tz:match("^UTC([+-]?)(%d+)$")
  elseif tz:match("^GMT[+-]?%d+$") then
    sign, hours = tz:match("^GMT([+-]?)(%d+)$")
  elseif tz_abbr[tz] then
    offset_seconds = tz_abbr[tz] * 3600
  else
    return base_time -- unknown tz, ignore
  end

  if hours then
    local h = tonumber(hours) or 0
    offset_seconds = (sign == "-" and -h or h) * 3600
  end

  local utc_time = base_time - os.difftime(base_time, os.time(os.date("!*t", base_time)))
  return utc_time + offset_seconds
end

return M
