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

- **`:InsertDate [FORMAT] [OFFSET]`**: Inserts the current date.
  - `FORMAT`: strftime-style date format (default if omitted), or a preset name
    defined in the `presets` configuration.
  - `OFFSET`: Relative date, e.g., `+3d` (3 days from today), `-1w` (1 week ago),
    `+1y-2m` (1 year forward, 2 months back).
    - Supported units: `d` (days), `w` (weeks), `m` (months), `y` (years).

- **`:InsertTime [FORMAT] [OFFSET]`**: Inserts the current time.
  - `FORMAT`: strftime-style time format (default if omitted), or a preset name
    defined in the `presets` configuration.
  - `OFFSET`: Relative time, e.g., `+2H` (2 hours from now), `-30M` (30 minutes
    ago), `+1H15M` (1 hour 15 minutes from now).
    - Supported units: `H` (hours), `M` (minutes), `S` (seconds).
- **`:InsertDateTime`**: Inserts the current date and time using the configured
  formats and separator.

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

## API

Besides the commands, DateTimeInserter also exposes a Lua API. This is useful
for snippet managers (like [LuaSnip](https://github.com/L3MON4D3/LuaSnip))
custom mappings, or other plugins that need formatted date/time strings without
inserting them directly.

### Examples

```lua
local dti = require("date-time-inserter")

-- Date only
print(dti.format_date("%Y-%m-%d"))        -- "2025-10-01"

-- Time only
print(dti.format_time("%H:%M:%S"))        -- "13:37:42"

-- Date + Time                            -- "01-10-2025 at 13:37"
print(dti.format_date_time("%d-%m-%Y", nil, "%H:%M", nil))
```

### Functions

- `format_date(fmt?, offset?)`: Returns a formatted date string.
  - `fmt`: optional `strftime` format (defaults to `config.date_format`)
  - `offset`: optional relative offset, e.g. `+2d`, `-1w`
- `format_time(fmt?, offset?)`: Returns a formatted time string.
  - `fmt`: optional `strftime` format (defaults to `config.time_format`)
  - `offset`: optional relative offset, e.g. `+3H`, `-30M`
- `format_date_time(date_fmt?, date_offset?, time_fmt?, time_offset?)`: Returns a
  formatted date and time string.
  - `date_fmt`: optional `strftime` date format (defaults to `config.date_format`)
  - `date_offset`: optional relative date offset, e.g. `+2d`, `-1w`
  - `time_fmt`: optional `strftime` time format (defaults to `config.time_format`)
  - `time_offset`: optional relative time offset, e.g. `+3H`, `-30M`

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
