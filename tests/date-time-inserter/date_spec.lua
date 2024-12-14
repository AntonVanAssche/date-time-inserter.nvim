-- tests/date-time-inserter/date_spec.lua

local M = require("date-time-inserter.date")
local assert = require("luassert")
local os = require("os")

local mock_date = "2024-12-14"
os.date = function()
  return mock_date
end

describe("Date Format Tests", function()
  it("should return the date in MM/DD/YYYY format", function()
    local result = M.setup("MMDDYYYY", "/")
    assert.are.same("12/14/2024", result)
  end)

  it("should return the date in DD/MM/YYYY format", function()
    local result = M.setup("DDMMYYYY", "/")
    assert.are.same("14/12/2024", result)
  end)

  it("should return the date in YYYY/MM/DD format", function()
    local result = M.setup("YYYYMMDD", "/")
    assert.are.same("2024/12/14", result)
  end)

  it("should work with a different separator", function()
    local result = M.setup("MMDDYYYY", "-")
    assert.are.same("12-14-2024", result)
  end)

  it("should handle formats with repeated characters", function()
    local result = M.setup("MMMMYYYYDD", "-")
    assert.are.same("12-2024-14", result)
  end)

  it("does not remove the last character if it's not the separator", function()
    local result = M.setup("MMDDYYYY", "")
    assert.are.same("12142024", result)
  end)
end)
