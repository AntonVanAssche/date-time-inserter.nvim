local plugin = require("date-time-inserter")

describe("Setup Tests", function()
  it("should work without opts", function()
    plugin.setup()
    assert.is_truthy(require("date-time-inserter.model.config").values)
  end)

  it("should work with empty opts", function()
    plugin.setup({})
    assert.is_truthy(require("date-time-inserter.model.config").values)
  end)

  it("should work with opts", function()
    plugin.setup({
      time_format = "%I:%M %p",
      date_format = "%Y-%m-%d",
      date_time_separator = " at ",
    })
    local cfg = require("date-time-inserter.model.config").values
    assert.are.same("%I:%M %p", cfg.time_format)
    assert.are.same("%Y-%m-%d", cfg.date_format)
  end)
end)
