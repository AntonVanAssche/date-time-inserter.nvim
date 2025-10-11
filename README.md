# DateTimeInserter

DateTimeInserter is a simple Neovim plugin that allows you to easily insert the
current date and/or time into your buffer.

![preview](./assets/preview.gif)

## Why use DateTimeInserter?

Unlike shell-based solutions that require the `date` command (which might not be
available on all systems), DateTimeInserter uses Lua's built-in `os.date()`
function. This ensures that inserting the date and time works on any system,
regardless of the operating system.

```lua
vim.keymap.set("n", "<leader>dt", ':r! date "+\\%d-\\%m-\\%Y" <CR>', {noremap = true})
vim.keymap.set("n", "<leader>tt", ':r! date "+\\%H:\\%M:\\%S" <CR>', {noremap = true})
````

## Installation

### Using `lazy.nvim`

```lua
{
  'AntonVanAssche/date-time-inserter.nvim',
  version = '*',
  lazy = false,
  opts = {
    -- your configuration here
  }
}
```

Other plugin managers are also supported, refer to their documentation for
installation instructions.

## Configuration

You can configure DateTimeInserter in either `init.lua` or `init.vim`, although
`init.lua` is recommended for better readability and performance.

### init.vim example

```vim
lua << END
  require('date-time-inserter').setup()
END
```

### init.lua example

```lua
require("date-time-inserter").setup({
    date_format = '%d-%m-%Y',
    time_format = '%H:%M',
    date_time_separator = ' at ',
    presets = {},
})
```

#### Configuration options

- `date_format`: Date structure using `strftime` format codes (e.g., `%d/%m/%Y`
  → `31/12/2022`).
- `time_format`: Time structure using `strftime` format codes (e.g., `%I:%M %p`
  → `11:59 AM`).
- `date_time_separator`: String that separates date and time (e.g., `' at '` →
  `31-12-2022 at 11:59 AM`).
- `presets`: Dictionary of user-defined named presets for date/time formats
  (e.g., `{ iso = "%Y-%m-%dT%H:%M:%S" }`).

If not configured, defaults are used.

## Commands

The plugin provides the following commands in normal mode:

- **`:InsertDate [FORMAT] [OFFSET] [TIMEZONE]`**: Inserts the current date.
  - `FORMAT`: strftime-style date format (default if omitted), or a preset name
    defined in the `presets` configuration.
  - `OFFSET`: Relative date, e.g., `+3d` (3 days from today), `-1w` (1 week ago),
    `+1y-2m` (1 year forward, 2 months back).
    - Supported units: `d` (days), `w` (weeks), `m` (months), `y` (years).
  - `TIMEZONE`: Adjusts the output for a given timezone. Supports both explicit
    UTC/GMT offsets (e.g., `UTC+2`, `GMT-5`) and common abbreviations.
  `PST`,
    - Accepted formats:
      - `UTC+2`, `UTC-5`, `GMT+1`, `GMT-3`
      - `EST`, `EDT`, `CST`, `CDT`, `MST`, `MDT`, `PST`, `PDT`, `CET`, `CEST`,
        `GMT`, `UTC`
    - If omitted, the system's local timezone is used.

- **`:InsertTime [FORMAT] [OFFSET] [TIMEZONE]`**: Inserts the current time.
  - `FORMAT`: strftime-style time format (default if omitted), or a preset name
    defined in the `presets` configuration.
  - `OFFSET`: Relative time, e.g., `+2H` (2 hours from now), `-30M` (30 minutes
    ago), `+1H15M` (1 hour 15 minutes from now).
    - Supported units: `H` (hours), `M` (minutes), `S` (seconds).
  - `TIMEZONE`: Adjusts the output for a given timezone. Supports both explicit
    UTC/GMT offsets (e.g., `UTC+2`, `GMT-5`) and common abbreviations.
    - Accepted formats:
      - `UTC+2`, `UTC-5`, `GMT+1`, `GMT-3`
      - `EST`, `EDT`, `CST`, `CDT`, `MST`, `MDT`, `PST`, `PDT`, `CET`, `CEST`,
        `GMT`, `UTC`
    - If omitted, the system's local timezone is used.
- **`:InsertDateTime [TIMEZONE]`**: Inserts the current date and time using the
  configured formats and separator.
  - `TIMEZONE`: Adjusts the output for a given timezone. Supports both explicit
    UTC/GMT offsets (e.g., `UTC+2`, `GMT-5`) and common abbreviations.
    - Accepted formats:
      - `UTC+2`, `UTC-5`, `GMT+1`, `GMT-3`
      - `EST`, `EDT`, `CST`, `CDT`, `MST`, `MDT`, `PST`, `PDT`, `CET`, `CEST`,
        `GMT`, `UTC`
    - If omitted, the system's local timezone is used.

## Recommended Key Mappings

```lua
vim.keymap.set(
  "n",
  "<leader>dt",
  "<cmd>InsertDate<CR>",
  {noremap = true, silent = true}
)

vim.keymap.set(
  "n",
  "<leader>tt",
  "<cmd>InsertTime<CR>",
  {noremap = true, silent = true}
)

vim.keymap.set(
  "n",
  "<leader>dtt",
  "<cmd>InsertDateTime<CR>",
  {noremap = true, silent = true}
)
```

## Lua API

DateTimeInserter now follows a **controller-based architecture**.
You can use either the *controller* layer (for buffer insertion) or the *model*
layer (for returning raw formatted values).

### Controller API

Handles buffer insertion logic — used by commands and can be called directly.

```lua
local controller = require("date-time-inserter.controller")

-- Insert directly into the buffer
controller.insert_date({ "+3d" })      -- date 3 days from now
controller.insert_time({ "+2H30M" })   -- time 2h30m from now
controller.insert_date_time()          -- date + time
```

These functions behave exactly like their corresponding `:Insert*` commands.

### Model API

Use this layer to **get formatted strings** without inserting them, ideal for
snippets, statuslines, or other plugins.

```lua
local date = require("date-time-inserter.model.date")
local time = require("date-time-inserter.model.time")

print(date.get("%Y-%m-%d"))   -- "2025-10-10"
print(time.get("%H:%M:%S"))   -- "13:37:00"
```

#### Functions

- `date.get(fmt?, offset?, tz?)` → returns formatted date string
- `time.get(fmt?, offset?, tz?)` → returns formatted time string

Both use the plugin configuration defaults if no format is given.

## Deprecations

The following old formats are deprecated:

**Date formats:**

- `MMDDYYYY` replaced with `%m-%d-%Y`
- `DDMMYYYY` replaced with `%d-%m-%Y`
- `YYYYMMDD` replaced with `%Y-%m-%d`
- `YYYYDDMM` replaced with `%Y-%d-%m`

**Time formats:**

- `12` replaced with `%I:%M %p`
- `24` replaced with `%H:%M`
- `show_seconds` append `:%S` to the time format instead

Deprecated formats are automatically converted to `strftime` equivalents with a
warning.

## License

MIT License. See [LICENSE.md](./LICENSE.md) for details.

## Contributing

Contributions are welcome! Open a pull request or an issue for bugs or feature requests.
