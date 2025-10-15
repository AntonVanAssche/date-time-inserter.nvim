local time = require("date-time-inserter.model.time")
local config = require("date-time-inserter.model.config")
local assert = require("luassert")

local real_os_date = os.date

os.date = function(fmt)
  if fmt == "!*t" or fmt == "*t" then
    return real_os_date(fmt)
  end

  local mock = {
    ["%H:%M:%S"] = "15:45:30",
    ["%H:%M"] = "15:45",
    ["%I:%M:%S %p"] = "03:45:30 PM",
    ["%I:%M %p"] = "03:45 PM",
  }

  return mock[fmt] or "?"
end

describe("Time Format Tests", function()
  before_each(function()
    config.setup({})
  end)

  it("strftime format with seconds", function()
    local result = time.get("%H:%M:%S")
    assert.are.same("15:45:30", result)
  end)

  it("strftime format without seconds", function()
    local result = time.get("%H:%M")
    assert.are.same("15:45", result)
  end)

  it("strftime 12-hour format", function()
    local result = time.get("%I:%M %p")
    assert.are.same("03:45 PM", result)
  end)

  it("falls back to default", function()
    local result = time.get(nil)
    assert.are.same("15:45", result)
  end)
end)
