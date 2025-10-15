local feedback = require("date-time-inserter.ui.feedback")

local M = {}

M.defaults = {
  date_format = "%d-%m-%Y",
  time_format = "%H:%M",
  date_time_separator = " at ",
  presets = {},
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

local function normalize_date_format(fmt)
  if deprecated_date_formats[fmt] then
    local new_fmt = deprecated_date_formats[fmt]
    feedback.warn(("Date format '%s' is deprecated, using '%s'"):format(fmt, new_fmt))
    return new_fmt
  end
  return fmt or M.defaults.date_format
end

local function normalize_time_format(fmt)
  local new_fmt = deprecated_time_formats[fmt]
  if new_fmt then
    feedback.warn(("Time format '%s' is deprecated, using '%s'"):format(fmt, new_fmt))
    return new_fmt
  end
  return fmt or M.defaults.time_format
end

function M.setup(opts)
  opts = opts or {}
  M.values = vim.tbl_deep_extend("force", M.defaults, opts)

  M.values.date_format = normalize_date_format(M.values.date_format)
  M.values.time_format = normalize_time_format(M.values.time_format)
end

return M
