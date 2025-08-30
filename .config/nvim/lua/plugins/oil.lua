return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>e"] = { function() require("oil").toggle_float() end, desc = "Open folder in Oil" },
          },
        },
      },
    },
  },
  opts = function()
    local get_icon = require("astroui").get_icon
    local config = {}

    config = {
      delete_to_trash = true,
      columns = {
        {
          "icon",
          default_file = get_icon "DefaultFile",
          directory = get_icon "FolderClosed",
        },
      },
      keymaps = {
        ["<S-h>"] = "actions.parent",
        ["<S-l>"] = "actions.select",
        ["g,"] = "actions.toggle_trash",
      },
      skip_confirm_for_simple_edits = true,
    }

    return config
  end,
}
