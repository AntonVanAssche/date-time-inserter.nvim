local M = {}

function M.error(msg)
  vim.api.nvim_err_writeln("DateTimeInserter: " .. msg)
end

function M.warn(msg)
  vim.api.nvim_echo({ { "DateTimeInserter: " .. msg, "WarningMsg" } }, true, {})
end

function M.info(msg)
  vim.api.nvim_echo({ { "DateTimeInserter: " .. msg, "Normal" } }, true, {})
end

return M
