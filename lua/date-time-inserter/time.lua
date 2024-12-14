local M = {}

local _get_time = function()
  return os.date("%H:%M:%S")
end

local _convert_time_to_config_format = function(time_format, show_seconds, time)
  local _time = ""
  local suffix = ""
  local hour = tonumber(string.sub(time, 1, 2))
  local minute = tonumber(string.sub(time, 4, 5))
  local second = tonumber(string.sub(time, 7, 8))

  if time_format == 12 then
    suffix = hour >= 12 and "PM" or "AM"
    hour = hour % 12
    if hour == 0 then
      hour = 12
    end
  end

  local suffix_str = ""
  if suffix ~= "" then
    suffix_str = " " .. suffix
  end

  if show_seconds then
    _time = string.format("%02d:%02d:%02d%s", hour, minute, second, suffix_str)
  else
    _time = string.format("%02d:%02d%s", hour, minute, suffix_str)
  end

  return _time
end

M.setup = function(time_format, show_seconds)
  local time = _convert_time_to_config_format(time_format, show_seconds, _get_time())
  return time
end

return M
