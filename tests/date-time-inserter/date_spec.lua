-- tests/date-time-inserter/date_spec.lua

local date = require("date-time-inserter.date")
local assert = require("luassert")

-- mock os.date to handle strftime formats
local mock_date_map = {
  ["%m/%d/%Y"] = "12/14/2024",
  ["%d-%m-%Y"] = "14-12-2024",
}

os.date = function(fmt)
  return mock_date_map[fmt] or "?"
end

describe("Date Format Tests", function()
  it("strftime format with separators works", function()
    local result = date.setup("%m/%d/%Y")
    assert.are.same("12/14/2024", result)
  end)

  it("strftime format with dashes works", function()
    local result = date.setup("%d-%m-%Y")
    assert.are.same("14-12-2024", result)
  end)

  it("falls back to default when nil", function()
    local result = date.setup(nil)
    assert.are.same("14-12-2024", result) -- default %d-%m-%Y
  end)
end)
