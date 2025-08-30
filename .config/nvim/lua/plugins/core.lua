local minecraft_icon = {
  color = "#a6e3a1",
  icon = "󰍳",
  name = "Minecraft",
}

---@type LazySpec
return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        jmc = minecraft_icon,
        mcfunction = minecraft_icon,
      },
    },
  },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false, },
  { "max397574/better-escape.nvim", enabled = false, }
}
