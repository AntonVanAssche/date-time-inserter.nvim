local config = require("date-time-inserter.model.config")
local utils = require("date-time-inserter.model.utils")

local M = {}

function M.get(fmt, offset)
  fmt = fmt or config.values.date_format
  local time = os.time()

  if offset then
    time = utils.apply_offset(time, offset)
  end

  return os.date(fmt, time)
end

return M
