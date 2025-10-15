local config = require("date-time-inserter.model.config")
local utils = require("date-time-inserter.model.utils")

local M = {}

function M.get(fmt, offset, tz)
  fmt = fmt or config.values.time_format
  local utc = utils.get_utc_time()

  if offset then
    utc = utils.apply_offset(utc, offset)
    if offset:find("[S]") and not fmt:find("%%S") then
      fmt = fmt .. ":%S"
    end
  end

  return os.date(fmt, utils.apply_tz(utc, tz))
end

return M
