-- Check whether the plugin is already loaded.
if _G.loaded_date_time_inserter then
    return
end

-- Assign commands to the functionality of the plugin.
vim.api.nvim_create_user_command('InsertDate', function() require('date-time-inserter').insert_date() end, {})
vim.api.nvim_create_user_command('InsertTime', function() require('date-time-inserter').insert_time() end, {})
vim.api.nvim_create_user_command('InsertDateTime', function() require('date-time-inserter').insert_date_time() end, {})

-- Set the plugin as loaded.
_G.loaded_date_time_inserter = true
