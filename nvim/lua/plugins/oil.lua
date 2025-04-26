return {
  "stevearc/oil.nvim",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>O"] = { function() require("oil").toggle_float() end, desc = "Open folder in Oil" },
          },
        },
      },
    },
  },
  opts = function()
    local get_icon = require("astroui").get_icon
    return { columns = { { "icon", default_file = get_icon "DefaultFile", directory = get_icon "FolderClosed" } } }
  end,
}
