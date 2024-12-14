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

Here is an example of how you can configure the plugin in your init.lua file.
The example below shows the default configuration, which you can customize by modifying the values of the different settings.

```lua
local date_time_inserter_status_ok, date_time_inserter = pcall(require, "date-time-inserter")
if not date_time_inserter_status_ok then
    return
end

date_time_inserter.setup {
    date_format = 'MMDDYYYY',
    date_separator = '/',
    date_time_separator = ' at ',
    time_format = 12,
    show_seconds = false,
}
```

You can customize the following settings:

- `date_format`: The format of the date. You can use the letters 'Y', 'M', and 'D' to represent the year, month, and day, respectively. The order of the letters determines the order of the date.
  - For example, 'MMDDYYYY' will result in a date in the format '12/31/2022'.
- `time_format`: The format of the time. Set to 12 for 12 hour time or 24 for 24 hour time.
  - For example, '12' will result in 1:00 PM instead of 13:00.
- `date_separator`: The character to use as a separator between the different parts of the date.
  - For example, a '-' will result in 12-31-2022.
- `date_time_separator`: The string to use as a separator between the different parts of the date and time.
  - For example, ' at ' will result in 12-31-2022 at 11:59 AM.
- `show_seconds`: Whether to include seconds in the time. Set to true to show seconds or false to hide them.
  - For example, 'true' will result in 11:59:41 AM instead of 11:59 AM.

If you do not configure Date Time Inserter or leave certain settings unconfigured, it will use its default settings for those settings.

## Usage

### commands

The plugin provides the following commands, which can be called in normal mode:

- `:InsertDate`: Inserts the current date into the buffer.
- `:InsertTime`: Inserts the current time into the buffer.
- `:InsertDateTime`: Inserts the current date and time into the buffer.

However, it's recommended to use the keybindings instead of the commands.

```lua
vim.keymap.set("n", "<leader>dt", ":InsertDate<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>tt", ":InsertTime<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>dtt", ":InsertDateTime<CR>", {noremap = true, silent = true})
```

## License

Date Time Inserter is licensed under the MIT License. See the [LICENSE.md](./LICENSE.md) file for more information.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.
