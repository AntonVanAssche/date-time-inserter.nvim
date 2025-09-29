-- tests/date-time-inserter/config_spec.lua

local config = require("date-time-inserter.config")
local assert = require("luassert")

-- mock vim.api for feedback
vim = vim or {}
vim.api = vim.api or {}
vim.api.nvim_err_writeln = function(msg)
  _G.last_error = msg
end
vim.api.nvim_echo = function(msgs, _, _)
  _G.last_echo = msgs[1][1]
end

describe("Configuration Tests", function()
  before_each(function()
    -- reset globals
    _G.last_error = nil
    _G.last_echo = nil
    config.config = {
      date_format = "%d-%m-%Y",
      time_format = "%H:%M",
      date_time_separator = " at ",
      show_seconds = false,
    }
  end)

  describe("Valid Configurations", function()
    it("accepts a valid strftime date format", function()
      config.setup({
        date_format = "%Y/%m/%d",
      })
      assert.are.same("%Y/%m/%d", config.config.date_format)
    end)

    it("accepts a valid strftime time format", function()
      config.setup({
        time_format = "%I:%M %p",
      })
      assert.are.same("%I:%M %p", config.config.time_format)
    end)

    it("sets a custom date time separator", function()
      config.setup({
        date_time_separator = " - ",
      })
      assert.are.same(" - ", config.config.date_time_separator)
    end)
  end)

  describe("Deprecated Configurations", function()
    it("converts legacy date format MMDDYYYY to strftime with dashes", function()
      config.setup({
        date_format = "MMDDYYYY",
      })
      assert.are.same("%m-%d-%Y", config.config.date_format)
      assert.is_not_nil(_G.last_echo)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("converts legacy date format DDMMYYYY to strftime with dashes", function()
      config.setup({
        date_format = "DDMMYYYY",
      })
      assert.are.same("%d-%m-%Y", config.config.date_format)
      assert.is_not_nil(_G.last_echo)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("converts legacy 12-hour time format", function()
      config.setup({
        time_format = 12,
      })
      assert.are.same("%I:%M %p", config.config.time_format)
      assert.is_not_nil(_G.last_echo)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("converts legacy 24-hour time format", function()
      config.setup({
        time_format = 24,
      })
      assert.are.same("%H:%M", config.config.time_format)
      assert.is_not_nil(_G.last_echo)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("adds seconds to time format when show_seconds is true", function()
      config.setup({
        time_format = "%H:%M",
        show_seconds = true,
      })
      assert.are.same("%H:%M:%S", config.config.time_format)
      assert.is_not_nil(_G.last_echo)
      assert.truthy(_G.last_echo:find("deprecated"))
    end)

    it("does not add seconds when show_seconds is false", function()
      config.setup({
        time_format = "%H:%M",
        show_seconds = false,
      })
      assert.are.same("%H:%M", config.config.time_format)
    end)
  end)

  describe("Fallback Handling", function()
    it("falls back to default date format when nil", function()
      config.setup({
        date_format = nil,
      })

      assert.are.same("%d-%m-%Y", config.config.date_format)
    end)

    it("falls back to default time format when nil", function()
      config.setup({
        time_format = nil,
      })
      assert.are.same("%H:%M", config.config.time_format)
    end)
  end)
end)
