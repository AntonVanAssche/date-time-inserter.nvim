if vim.g.loaded_date_time_inserter then
  return
end

require("date-time-inserter").setup()

vim.g.loaded_date_time_inserter = true
