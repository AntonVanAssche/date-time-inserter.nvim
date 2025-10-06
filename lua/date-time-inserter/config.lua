local M = {}
local feedback = require("date-time-inserter.ui.feedback")

local default_date_format = "%d-%m-%Y"
local default_time_format = "%H:%M"

M.config = {
  date_format = default_date_format,
  time_format = default_time_format,
  date_time_separator = " at ",
  show_seconds = nil,
}

local deprecated_date_formats = {
  ["MMDDYYYY"] = "%m-%d-%Y",
  ["DDMMYYYY"] = "%d-%m-%Y",
  ["YYYYMMDD"] = "%Y-%m-%d",
  ["YYYYDDMM"] = "%Y-%d-%m",
}

local deprecated_time_formats = {
  [12] = "%I:%M %p",
  [24] = "%H:%M",
}

local function validate_date_format(fmt)
  local replacement = deprecated_date_formats[fmt]
    or deprecated_date_formats[string.upper(tostring(fmt))]
  if replacement then
    feedback.warn(
      string.format("Date format '%s' is deprecated, using '%s' instead.", fmt, replacement)
    )
    return replacement
  end

  if not fmt or fmt == "" then
    feedback.info(string.format("Using default date format '%s'.", default_date_format))
    return default_date_format
  end

  return fmt
end

local function validate_time_format(fmt, show_seconds)
  local replacement

  if deprecated_time_formats[fmt] then
    replacement = deprecated_time_formats[fmt]
  elseif deprecated_time_formats[tonumber(fmt)] then
    replacement = deprecated_time_formats[tonumber(fmt)]
  end

  if replacement then
    feedback.warn(
      string.format(
        "Time format '%s' is deprecated, using '%s' instead.",
        tostring(fmt),
        replacement
      )
    )
    fmt = replacement
  end

  if show_seconds ~= nil then
    feedback.warn("'show_seconds' is deprecated, append ':%S' to time format instead.")
    if show_seconds then
      if not fmt:find("%%S") then
        fmt = fmt .. ":%S"
      end
    end
  end

  if type(fmt) ~= "string" or fmt == "" then
    feedback.info(string.format("Using default time format '%s'.", default_time_format))
    fmt = default_time_format
  end

  return fmt
end

M.setup = function(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  M.config.date_format = validate_date_format(M.config.date_format)
  M.config.time_format = validate_time_format(M.config.time_format, M.config.show_seconds)
end

return M
