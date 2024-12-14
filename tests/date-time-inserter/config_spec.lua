-- tests/date-time-inserter/config_spec.lua

local M = require("date-time-inserter.config")
local assert = require("luassert")

local function capture_print(func)
  local output = ""
  local original_print = print
  print = function(str)
    output = output .. str .. "\n"
  end
  func()
  print = original_print
  return output
end

describe("Configuration Tests", function()
  describe("Valid Configurations", function()
    it("should correctly set a valid date format (DDMMYYYY)", function()
      M.setup({
        date_format = "DDMMYYYY",
        time_format = 12,
      })
      assert.are.same(M.config.date_format, "DDMMYYYY")
    end)

    it("should correctly set a valid time format (24-hour)", function()
      M.setup({
        date_format = "MMDDYYYY",
        time_format = 24,
      })
      assert.are.same(M.config.time_format, 24)
    end)

    it("should set a custom date separator (dash)", function()
      M.setup({
        date_separator = "-",
      })
      assert.are.same(M.config.date_separator, "-")
    end)

    it("should set a custom date time separator (<space>dash<space>)", function()
      M.setup({
        date_time_separator = " - ",
      })
      assert.are.same(M.config.date_time_separator, " - ")
    end)
  end)

  describe("Invalid Configurations", function()
    it("should fall back to default date format for invalid length (MMDDYY)", function()
      M.setup({
        date_format = "MMDDYY",
      })
      assert.are.same(M.config.date_format, "MMDDYYYY")
    end)

    it("should fall back to default date format for missing components (MMDDMM)", function()
      M.setup({
        date_format = "MMDDMM",
      })
      assert.are.same(M.config.date_format, "MMDDYYYY")
    end)

    it("should fall back to default time format for invalid time format (10)", function()
      M.setup({
        time_format = 10,
      })
      assert.are.same(M.config.time_format, 12)
    end)

    it("should print an error for invalid date format length (MMDDYY)", function()
      local result = capture_print(function()
        M.setup({
          date_format = "MMDDYY",
        })
      end)
      assert.equal(1, result:find("INVALID_DATE_FORMAT"))
    end)

    it("should print an error for invalid time format (10)", function()
      local result = capture_print(function()
        M.setup({
          time_format = 10,
        })
      end)
      assert.equal(1, result:find("INVALID_TIME_FORMAT"))
    end)
  end)

  describe("Edge Case Handling", function()
    it("should handle invalid date format (missing 'DD')", function()
      local result = capture_print(function()
        M.setup({
          date_format = "MMYY",
        })
      end)
      assert.are.equal(1, result:find("INVALID_DATE_FORMAT"))
    end)

    it("should handle invalid date format (contains extra 'M')", function()
      local result = capture_print(function()
        M.setup({
          date_format = "MMMDDYYYY",
        })
      end)
      assert.equal(1, result:find("INVALID_DATE_FORMAT"))
    end)
  end)
end)
