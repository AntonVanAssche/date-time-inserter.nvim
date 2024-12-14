-- Check whether the plugin is already loaded.
if vim.g.loaded_date_time_inserter then
  return
end

require("date-time-inserter").setup()
require("date-time-inserter.command").setup()

vim.g.loaded_date_time_inserter = true
