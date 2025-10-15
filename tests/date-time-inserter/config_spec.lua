local config = require("date-time-inserter.model.config")
local feedback = require("date-time-inserter.ui.feedback")
local assert = require("luassert")

-- Mock vim.api for feedback
vim = vim or {}
vim.api = vim.api or {}
vim.api.nvim_err_writeln = function(msg) _G.last_error = msg end
vim.api.nvim_echo = function(msgs, _, _) _G.last_echo = msgs[1][1] end

describe("Configuration Tests", function()
  before_each(function()
    _G.last_echo = nil
    _G.last_error = nil
  end)

  describe("Valid Configurations", function()
    it("accepts a valid strftime date format", function()
      config.setup({ date_format = "%Y/%m/%d" })
      assert.are.same("%Y/%m/%d", config.values.date_format)
    end)

    it("accepts a valid strftime time format", function()
      config.setup({ time_format = "%I:%M %p" })
      assert.are.same("%I:%M %p", config.values.time_format)
    end)

    it("sets a custom date time separator", function()
      config.setup({ date_time_separator = " - " })
      assert.are.same(" - ", config.values.date_time_separator)
    end)
  end)

  describe("Deprecated Configurations", function()
    it("converts legacy date format MMDDYYYY to strftime", function()
      config.setup({ date_format = "MMDDYYYY" })
      assert.are.same("%m-%d-%Y", config.values.date_format)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("converts legacy 12-hour time format", function()
      config.setup({ time_format = 12 })
      assert.are.same("%I:%M %p", config.values.time_format)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)
  end)

  describe("Fallback Handling", function()
    it("falls back to default date format when nil", function()
      config.setup({ date_format = nil })
      assert.are.same("%d-%m-%Y", config.values.date_format)
    end)

    it("falls back to default time format when nil", function()
      config.setup({ time_format = nil })
      assert.are.same("%H:%M", config.values.time_format)
    end)
  end)
end)
