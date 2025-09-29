local M = {}
local config = require("date-time-inserter.config")

M.setup = function(override_format)
  local fmt = override_format or config.config.date_format
  local base_time = os.time()
  return os.date(fmt, base_time)
end

return M
