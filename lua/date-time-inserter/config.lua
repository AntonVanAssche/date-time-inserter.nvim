local M = {}

local default_date_format = "MMDDYYYY"
local default_time_format = 12

M.config = {
  date_format = default_date_format,
  date_separator = "/",
  date_time_separator = " at ",
  time_format = default_time_format,
  show_seconds = false,
}

local _validate_date_format = function(date_format)
  if string.len(date_format) ~= 8 then
    print("INVALID_DATE_FORMAT: Date format must be 8 characters long (e.g. MMDDYYYY).")
    return default_date_format
  end

  if
    not string.find(date_format, "M")
    or not string.find(date_format, "D")
    or not string.find(date_format, "Y")
  then
    print(
      "INVALID_DATE_FORMAT: Date format must contain the characters M, D and Y (e.g. MMDDYYYY)."
    )
    return default_date_format
  end

  if string.find(date_format, "DD") == nil then
    print(
      'INVALID_DATE_FORMAT: Date format must contain exactly one occurrence of the "DD" string (e.g. MMDDYYYY).'
    )
    return default_date_format
  end

  if string.find(date_format, "MM") == nil then
    print(
      'INVALID_DATE_FORMAT: Date format must contain exactly one occurrence of the "MM" string (e.g. MMDDYYYY).'
    )
    return default_date_format
  end

  if string.find(date_format, "YYYY") == nil then
    print(
      'INVALID_DATE_FORMAT: Date format must contain exactly one occurrence of the "YYYY" string (e.g. MMDDYYYY).'
    )
    return default_date_format
  end

  return date_format
end

local _validate_time_format = function(time_format)
  if time_format ~= 12 and time_format ~= 24 then
    print("INVALID_TIME_FORMAT: Time format must be either 12 or 24.")
    return default_time_format
  end

  return time_format
end

M.setup = function(opts)
  opts = opts or {}

  for k, v in pairs(opts) do
    M.config[k] = v
  end

  M.config.date_format = _validate_date_format(M.config.date_format)
  M.config.time_format = _validate_time_format(M.config.time_format)
end

return M
