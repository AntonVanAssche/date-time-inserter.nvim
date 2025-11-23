local config = require("date-time-inserter.model.config")
local utils = require("date-time-inserter.model.utils")

local M = {}

function M.get(fmt, offset, tz)
  fmt = fmt or config.values.time_format
  local base_time = os.time()

  if offset then
    base_time = utils.apply_offset(base_time, offset)
    if offset:find("[S]") and not fmt:find("%%S") then
      fmt = fmt .. ":%S"
    end
  end

  return os.date(fmt, utils.apply_tz(base_time, tz))
end

return M
