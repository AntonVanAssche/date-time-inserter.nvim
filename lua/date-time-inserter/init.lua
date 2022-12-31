local M = {}

-- Default settings.
local settings = {
    date_format = 'MMDDYYYY', -- DDMMYYYY, MMDDYYYY, YYYYMMDD or whatever you want.
                              -- As long as it's in the same format without spaces or other characters.

    date_separator = '/',     -- Character used to separate the date parts.

    time_format = 12,         -- Can be 24 or 12 for 24 hour or 12 hour time.

    show_seconds = false,     -- Whether to show seconds in the time (true) or not (false)
}

-- Convert the date returned by os.date() to the format specified in the settings.
-- @param date: Date returned by os.date().
local function convert_date_to_config_format(date)
    -- Convert the format to uppercase, safety guard in case the user used lowercase letters.
    local date_format = string.upper(settings.date_format)
    local separator = settings.date_separator
    local new_date = ''

    -- Extract the year, month and day from the date string
    local year = date:sub(1, 4)
    local month = date:sub(6, 7)
    local day = date:sub(9, 10)

    -- Table to store the different parts of the date.
    -- This allows us to easily access the different parts of the date
    -- when constructing the final string with the desired format.
    local date_table = {
        ['Y'] = year,
        ['M'] = month,
        ['D'] = day,
    }

    -- Loop through the date format and add the date to the new date
    -- in the order specified by the user
    -- e.g. MMDDYYYY -> 12/31/2022
    -- e.g. DDMMYYYY -> 31/12/2022
    local incuded = {}
    for char in date_format:gmatch('.') do
        if not incuded[char] then
            new_date = new_date .. date_table[char] .. separator
            incuded[char] = true
        end
    end

    -- Remove the last separator
    -- e.g. 12/31/2022/ -> 12/31/2022
    new_date = new_date:sub(1, -2)

    return new_date
end

-- Convert the time returned by os.date() to the format specified in the settings.
-- @param time: Time returned by os.date().
local function convert_time_to_config_format(time)
    local time_format = settings.time_format

    -- Extract the hour, minute and second from the time string
    local hour = time:sub(1, 2)
    local minute = time:sub(4, 5)
    local second = time:sub(7, 8)

    -- Check whether to return the time in 12 or 24 hour format.
    -- If the time format is 12, we need to convert the hour to 12 hour format.
    -- e.g. 13:00:00 -> 1:00:00 PM
    if time_format == 12 then
        if tonumber(hour) > 12 then
            hour = tostring(tonumber(hour) - 12)
            time = hour .. ':' .. minute .. ' PM'
        else
            -- Check whether the time should be displayed with seconds.
            if settings.show_seconds then
                time = hour .. ':' .. minute .. ':' .. second .. ' AM'
            else
                time = hour .. ':' .. minute .. ' AM'
            end
        end
    else
        -- Check whether the time should be displayed with seconds.
        if settings.show_seconds then
            time = hour .. ':' .. minute .. ':' .. second
        else
            time = hour .. ':' .. minute
        end
    end

    return time
end

-- Set the settings, if any where passed.
-- If none are passed, the default settings will be used.
-- @param opts: Plugin settings.
M.setup = function(opts)
    if opts then
        for k, v in pairs(opts) do
            settings[k] = v
        end
    end
end

-- Insert the current date into the current buffer.
-- The date will be inserted at the cursor position.
M.insert_date = function()
    -- Get the current date.
    local date = os.date('%Y-%m-%d')

    -- Convert the date to the format specified in the settings.
    local date_format = convert_date_to_config_format(date)

    -- Insert the date at the cursor position.
    vim.api.nvim_put({date_format}, 'c', true, true)
end

-- Insert the current time into the current buffer.
-- The time will be inserted at the cursor position.
M.insert_time = function()
    -- Get the current time.
    local time = os.date('%H:%M:%S')

    -- Convert the time to the format specified in the settings.
    local time_format = convert_time_to_config_format(time)

    -- Insert the time at the cursor position.
    vim.api.nvim_put({time_format}, 'c', true, true)
end

return M
