local M = {}
local config = require("date-time-inserter.config")
local utils = require("date-time-inserter.utils")

M.setup = function(override_format, offset)
  local fmt = override_format or config.config.date_format
  local base_time = os.time()

  if type(offset) == "string" and offset:match("^[+-]") then
    base_time = utils.apply_offset_date(base_time, offset)
  end

  return os.date(fmt, base_time)
end

return M
