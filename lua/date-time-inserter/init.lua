local config = require("date-time-inserter.model.config")
local controller = require("date-time-inserter.controller")

local M = {}

function M.setup(opts)
  config.setup(opts)
  controller.register_commands()
end

return M
