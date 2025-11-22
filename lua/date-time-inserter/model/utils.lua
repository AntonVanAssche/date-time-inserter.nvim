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

local function is_tz(arg)
  return arg:match("^UTC[+-]?%d+$") or arg:match("^GMT[+-]?%d+$") or tz_abbr[arg] ~= nil
end

local function is_format(arg)
  return arg:find("%%") ~= nil
end

local function extract_offsets(arg)
  local results = {}

  local leading = arg:match("^([+-])")
  local body = leading and arg:sub(2) or arg

  for sign, num, unit in body:gmatch("([+-]?)(%d+)([ymdHMS])") do
    -- if the token has no sign, inherit the leading one (if any)
    local final_sign = (sign ~= "" and sign) or leading or "+"
    table.insert(results, final_sign .. num .. unit)
  end

  return results
end

function M.parse_args(fargs, presets)
  if #fargs == 0 then
    return nil, nil, nil
  end

  local fmt_parts = {}
  local offset_parts = {}
  local tz = nil

  for _, arg in ipairs(fargs) do
    if is_tz(arg) then
      tz = arg
    elseif is_format(arg) then
      table.insert(fmt_parts, arg)
    elseif arg:match("[+-]%d+[ymdHMS]") then
      for _, off in ipairs(extract_offsets(arg)) do
        table.insert(offset_parts, off)
      end
    else
      -- treat as preset key
      table.insert(fmt_parts, arg)
    end
  end

  local fmt = (#fmt_parts > 0) and table.concat(fmt_parts, " ") or nil
  local offset = (#offset_parts > 0) and table.concat(offset_parts, " ") or nil

  -- Only preset-lookup when format doesn't contain %
  if fmt and presets and not fmt:find("%%") then
    if presets[fmt] then
      fmt = presets[fmt]
    else
      feedback.error(("Unknown date/time preset: '%s'"):format(fmt))
      fmt = nil
    end
  end

  return fmt, offset, tz
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

  local local_sign, local_h, local_m = os.date("%z"):match("([+-])(%d%d)(%d%d)")
  local local_offset = 0
  if local_sign then
    local_offset = tonumber(local_h) * 3600 + tonumber(local_m) * 60
    if local_sign == "-" then
      local_offset = -local_offset
    end
  end

  local offset_seconds = 0
  local sign, hours = tz:match("^UTC([+-]?)(%d+)$")
  if not hours then
    sign, hours = tz:match("^GMT([+-]?)(%d+)$")
  end

  if hours then
    local h = tonumber(hours)
    offset_seconds = (sign == "-" and -h or h) * 3600
  elseif tz_abbr[tz] then
    offset_seconds = tz_abbr[tz] * 3600
  else
    return base_time
  end

  local utc = base_time - local_offset
  return utc + offset_seconds
end

return M
