local plugin = require("date-time-inserter")

describe("Setup Tests", function()
  it("should work without opts", function()
    plugin.setup()
  end)

  it("should work with empty opts", function()
    plugin.setup({})
  end)

  it("should work with opts", function()
    plugin.setup({
      time_format = 12,
      show_seconds = true,
    })
  end)
end)
