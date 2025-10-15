local config = require("date-time-inserter.model.config")
local utils = require("date-time-inserter.model.utils")
local assert = require("luassert")

-- Fixed base time: 2024-01-01 12:00:00 UTC
local BASE_TIME = os.time({
  year = 2024,
  month = 1,
  day = 1,
  hour = 12,
  min = 0,
  sec = 0,
  isdst = false,
})

describe("Offset Tests", function()
  before_each(function()
    config.setup({})
  end)

  it("adds hours correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+2H")
    assert.are.same(BASE_TIME + (2 * 3600), result)
  end)

  it("subtracts hours correctly", function()
    local result = utils.apply_offset(BASE_TIME, "-3H")
    assert.are.same(BASE_TIME - (3 * 3600), result)
  end)

  it("adds minutes correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+30M")
    assert.are.same(BASE_TIME + (30 * 60), result)
  end)

  it("adds seconds correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+45S")
    assert.are.same(BASE_TIME + 45, result)
  end)

  it("adds days correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+1d")
    local expected = os.time({
      year = 2024,
      month = 1,
      day = 2,
      hour = 12,
      min = 0,
      sec = 0,
      isdst = false,
    })
    assert.are.same(expected, result)
  end)

  it("adds months correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+1m")
    local expected = os.time({
      year = 2024,
      month = 2,
      day = 1,
      hour = 12,
      min = 0,
      sec = 0,
      isdst = false,
    })
    assert.are.same(expected, result)
  end)

  it("adds years correctly", function()
    local result = utils.apply_offset(BASE_TIME, "+1y")
    local expected = os.time({
      year = 2025,
      month = 1,
      day = 1,
      hour = 12,
      min = 0,
      sec = 0,
      isdst = false,
    })
    assert.are.same(expected, result)
  end)

  it("handles multiple offsets in one string", function()
    local result = utils.apply_offset(BASE_TIME, "+1d+2H+30M")
    local expected = BASE_TIME + (1 * 86400) + (2 * 3600) + (30 * 60)
    assert.are.same(expected, result)
  end)

  it("handles negative mixed offsets", function()
    local result = utils.apply_offset(BASE_TIME, "-1d-1H-10M")
    local expected = BASE_TIME - (1 * 86400) - (1 * 3600) - (10 * 60)
    assert.are.same(expected, result)
  end)

  it("returns same time when no valid pattern is matched", function()
    local result = utils.apply_offset(BASE_TIME, "nonsense")
    assert.are.same(BASE_TIME, result)
  end)
end)

describe("Timezone Conversion Tests", function()
  before_each(function()
    config.setup({})
  end)

  it("applies UTC+0 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "UTC+0")
    assert.are.same(BASE_TIME, adjusted)
  end)

  it("applies UTC-0 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "UTC-0")
    assert.are.same(BASE_TIME, adjusted)
  end)

  it("applies UTC+2 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "UTC+2")
    assert.is_true(adjusted > BASE_TIME)
    assert.are.same(BASE_TIME + (2 * 3600), adjusted)
  end)

  it("applies UTC-5 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "UTC-5")
    assert.are.same(BASE_TIME - (5 * 3600), adjusted)
  end)

  it("applies GMT+0 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "GMT+0")
    assert.are.same(BASE_TIME, adjusted)
  end)

  it("applies GMT-0 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "GMT-0")
    assert.are.same(BASE_TIME, adjusted)
  end)

  it("applies GMT-4 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "GMT-4")
    assert.are.same(BASE_TIME - (4 * 3600), adjusted)
  end)

  it("applies GMT+3 correctly", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "GMT+3")
    assert.are.same(BASE_TIME + (3 * 3600), adjusted)
  end)

  it("applies abbreviation CET (+1)", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "CET")
    assert.are.same(BASE_TIME + 3600, adjusted)
  end)

  it("applies abbreviation PST (-8)", function()
    os.time = function() return BASE_TIME end
    local adjusted = utils.apply_tz(BASE_TIME, "PST")
    assert.are.same(BASE_TIME - (8 * 3600), adjusted)
  end)

  it("returns unchanged when tz is nil", function()
    local adjusted = utils.apply_tz(BASE_TIME, nil)
    assert.are.same(BASE_TIME, adjusted)
  end)

  it("returns unchanged for invalid tz", function()
    local adjusted = utils.apply_tz(BASE_TIME, "MarsTime")
    assert.are.same(BASE_TIME, adjusted)
  end)
end)
