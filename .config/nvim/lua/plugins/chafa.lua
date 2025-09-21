return {
  "Frederick888/chafa.nvim",
  branch = "new-chafa",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim"
  },
  opts = {
    render = {
      min_padding = 5,
      show_label = true,
    },
    events = {
      update_on_nvim_resize = true,
    },
  },
}
