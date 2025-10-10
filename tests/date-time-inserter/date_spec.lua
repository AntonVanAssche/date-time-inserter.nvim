local date = require("date-time-inserter.model.date")
local config = require("date-time-inserter.model.config")
local assert = require("luassert")

os.date = function(fmt)
  if fmt == "%m/%d/%Y" then return "12/14/2024" end
  if fmt == "%d-%m-%Y" then return "14-12-2024" end
  return "?"
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
