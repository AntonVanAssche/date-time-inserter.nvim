local date = require("date-time-inserter.model.date")
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
    ["%m/%d/%Y"] = "12/14/2024",
    ["%d-%m-%Y"] = "14-12-2024",
  }
  return mock[fmt] or "?"
end

describe("Date Format Tests", function()
  before_each(function()
    config.setup({})
  end)

  it("strftime format with slashes", function()
    local result = date.get("%m/%d/%Y")
    assert.are.same("12/14/2024", result)
  end)

  it("strftime format with dashes", function()
    local result = date.get("%d-%m-%Y")
    assert.are.same("14-12-2024", result)
  end)

  it("falls back to default format", function()
    local result = date.get(nil)
    assert.are.same("14-12-2024", result)
  end)
end)
