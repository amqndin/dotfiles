return {
  "leath-dub/snipe.nvim",
  event = "User AstroFile",
  keys = {
    {
      "<Leader>h",
      function () require("snipe").open_buffer_menu() end,
      desc = "Open Snipe buffer menu"
    }
  },
  opts = {
    hints = {
      dictionary = "sadfjkl;ghweio",
    },
  }
}
