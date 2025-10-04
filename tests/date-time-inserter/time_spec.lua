-- tests/date-time-inserter/time_spec.lua

local time = require("date-time-inserter.time")
local assert = require("luassert")

-- mock os.date
local mock_time = {
  ["%H:%M:%S"] = "15:45:30",
  ["%H:%M"] = "15:45",
  ["%I:%M:%S %p"] = "03:45:30 PM",
  ["%I:%M %p"] = "03:45 PM",
  ["%I:%M:%S %p_AM"] = "12:15:10 AM", -- simulate AM
  ["%I:%M %p_AM"] = "12:15 AM",
}

os.date = function(fmt)
  return mock_time[fmt] or "?"
end

describe("Time Format Tests", function()
  it("strftime format with seconds", function()
    local result = time.setup("%H:%M:%S")
    assert.are.same("15:45:30", result)
  end)

  it("strftime format without seconds", function()
    local result = time.setup("%H:%M")
    assert.are.same("15:45", result)
  end)

  it("strftime 12-hour format", function()
    local result = time.setup("%I:%M %p")
    assert.are.same("03:45 PM", result)
  end)

  it("falls back to default when nil", function()
    local result = time.setup(nil, false)
    assert.are.same("15:45", result) -- default is %H:%M
  end)
end)
