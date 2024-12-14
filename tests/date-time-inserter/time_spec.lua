-- tests/date-time-inserter/time_spec.lua

local M = require("date-time-inserter.time")
local assert = require("luassert")
local os = require("os")

local mock_time = "15:45:30"
os.date = function()
  return mock_time
end

describe("Time Format Tests", function()
  it("should return the time in 24-hour format with seconds", function()
    local result = M.setup(24, true)
    assert.are.same("15:45:30", result)
  end)

  it("should return the time in 24-hour format without seconds", function()
    local result = M.setup(24, false)
    assert.are.same("15:45", result)
  end)

  it("should return the time in 12-hour format with seconds (PM)", function()
    local result = M.setup(12, true)
    assert.are.same("03:45:30 PM", result)
  end)

  it("should return the time in 12-hour format without seconds (PM)", function()
    local result = M.setup(12, false)
    assert.are.same("03:45 PM", result)
  end)

  it("should return the time in 12-hour format with seconds (AM)", function()
    mock_time = "00:15:10"
    local result = M.setup(12, true)
    assert.are.same("12:15:10 AM", result)
  end)

  it("should return the time in 12-hour format without seconds (AM)", function()
    mock_time = "00:15:10"
    local result = M.setup(12, false)
    assert.are.same("12:15 AM", result)
  end)

  it("should handle midnight in 12-hour format with seconds (AM)", function()
    os.date = function()
      return "00:15:10"
    end
    local result = M.setup(12, true)
    assert.are.same("12:15:10 AM", result)
  end)

  it("should handle midnight in 24-hour format with seconds", function()
    os.date = function()
      return "00:15:10"
    end
    local result = M.setup(24, true)
    assert.are.same("00:15:10", result)
  end)

  it("should handle noon in 12-hour format without seconds (PM)", function()
    os.date = function()
      return "12:00:00"
    end
    local result = M.setup(12, false)
    assert.are.same("12:00 PM", result)
  end)

  it("should handle noon in 24-hour format with seconds", function()
    os.date = function()
      return "12:00:00"
    end
    local result = M.setup(24, true)
    assert.are.same("12:00:00", result)
  end)
end)
