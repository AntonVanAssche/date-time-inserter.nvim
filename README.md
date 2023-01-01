# Date Time Inserter

Date Time Inserter is a simple/basic Neovim plugin that allows you to easily insert the current date and time into your Neovim buffer.

![preview](./assets/preview.gif)

## Why?

This plugin does basically the same as the code block below, but this requires the `date` command to be installed on the system.
Therefore it's not always possible to use it on every system, this is exactly what Date Time Inserter tries to solve by using the lua built-in `os.date()` function.
The plugin allows you to insert the date and time into your Neovim buffer on every system regardless of the operating system.

```lua
vim.keymap.set("n", "<leader>dt", ':r! date "+\\%d-\\%m-\\%Y" <CR>', {noremap = true, vim.keymap.set})
vim.keymap.set("n", "<leader>tt", ':r! date "+\\%H:\\%M:\\%S" <CR>', {noremap = true, vim.keymap.set})
```

## Warning

Please note that this is my first plugin for Neovim, so it may not be as efficient or polished as other plugins.
This is probably due to my **REALLY** basic knowledge of lua or my **~~shitty~~** programming brain 😅.
Jokes a side feedback and suggestions are **ALWAYS** welcome 😉!

## Installation

### Using [Packer](https://github.com/wbthomason/packer.nvim)

1. Add this to your Neovim config:

```lua
use { 'AntonVanAssche/date-time-inserter.nvim' }
```

2. Run `:PackerSync` to install the plugin on your machine.

### Using [Vim-Plug](https://github.com/junegunn/vim-plug)

1. Add the following to your Neovim config:

```vim
Plug 'AntonVanAssche/date-time-inserter.nvim'
```

2. Run `:PlugInstall` to install the plugin on your machine.

### Manually

1. Clone this repository into your Neovim ~/.config/nvim/pack/plugins/start/directory.

## Configuration

You can configure the plugin by adding the following to your init.lua:

### Configuring Date Time Inserter in init.vim

All the examples below are in lua. You can use the same examples in .vim files by wrapping them in lua heredoc like this:

```vim
lua << END
    require('date-time-inserter').setup()
END
```

### Configuring Date Time Inserter in init.lua

#### Default configuration

```lua
local date_time_inserter_status_ok, date_time_inserter = pcall(require, "date-time-inserter")
if not date_time_inserter_status_ok then
    return
end

date_time_inserter.setup {
    date_format = 'MMDDYYYY',
    date_separator = '/',
    time_format = 12,
    show_seconds = false,
    insert_date_map = '<leader>dt',
    insert_time_map = '<leader>tt',
    insert_date_time_map = '<leader>dtt',
}
```

You can customize the following settings:

-   `date_format`: The format of the date. You can use the letters 'Y', 'M', and 'D' to represent the year, month, and day, respectively. The order of the letters determines the order of the date.
    -   For example, 'MMDDYYYY' will result in a date in the format '12/31/2022'.
-   `time_format`: The format of the time. Set to 12 for 12 hour time or 24 for 24 hour time.
    -   For example, '12' will result in 1:00 PM instead of 13:00.
-   `date_separator`: The character to use as a separator between the different parts of the date.
    -   For example, a '-' will result in 12-31-2022.
-   `show_seconds`: Whether to include seconds in the time. Set to true to show seconds or false to hide them.
    -   For example, 'true' will result in 11:59:41 AM instead of 11:59 AM.
-   `insert_date_map`: The keymap (in normal mode) used to insert the date.
    -   For example, when the key combination '<leader>dt' is pressed, the date will be inserted.
-   `insert_time_map`: The keymap (in normal mode) used to insert the time.
    -   For example, when the key combination '<leader>tt' is pressed, the time will be inserted.
-   `insert_date_time_map`: The keymap (in normal mode) used to insert the date and time.
    -   For example, when the key combination '<leader>dtt' is pressed, the date and time will be inserted.

#### Starting Date Time Inserter

```lua
require('date-time-inserter').setup()
```

**NOTE**: This will start Date Time Inserter with it's default configuration (refer to the header above).

## Usage

### Using keybindings

To use Date Time Inserter, you simply need to press the key combination you specified in the configuration file.
For example, if you set insert_date_map to '<leader>dt', pressing <leader>dt in normal mode will insert the current date into the buffer.
Similarly, pressing the key combination you specified for insert_time_map or insert_date_time_map will insert the current time or both the date and time, respectively.

### Using commands

You can also use the commands like ':InsertDate', ':InsertTime', and ':InsertDateTime' to call the plugin (in normal mode).

For example:

```
:InsertDate
:InsertTime
:InsertDateTime
```

## License

Date Time Inserter is licensed under the MIT License. See the [LICENSE.md](./LICENSE.md) file for more information.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.
