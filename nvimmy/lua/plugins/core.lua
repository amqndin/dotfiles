local minecraft_icon = {
  color = "#a6e3a1",
  icon = "󰍳",
  deviconscterm_color = "65",
  name = "minecraft",
}

---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = { window = { position = "float" } },
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_extension = {
        jmc = minecraft_icon,
        mcfunction = minecraft_icon,
      },
    },
  },
}
