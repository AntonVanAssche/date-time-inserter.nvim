local M = {}

local _get_date = function()
  return os.date("%Y-%m-%d")
end

local _convert_date_to_config_format = function(date_format, date_separator, date)
  local _date = ""

  local year = string.sub(date, 1, 4)
  local month = string.sub(date, 6, 7)
  local day = string.sub(date, 9, 10)
  local date_table = {
    ["Y"] = year,
    ["M"] = month,
    ["D"] = day,
  }

  local included = {}
  for char in date_format:gmatch(".") do
    if not included[char] then
      _date = _date .. date_table[char] .. date_separator
      included[char] = true
    end
  end

  -- Remove trailing date separator if it exists.
  -- e.g. 12/31/2022/ -> 12/31/2022
  -- e.g. 12312022    -> 12312022
  if _date:sub(-1) == date_separator then
    _date = _date:sub(1, -2)
  end

  return _date
end

M.setup = function(date_format, date_separator)
  local date = _convert_date_to_config_format(date_format, date_separator, _get_date())
  return date
end

return M
