return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = 'VimEnter',
  opts = {
    enabled = true,
    log_level = vim.log.levels.INFO,
    display = {
      theme = 'minecraft',
      flavor = 'accent',
      view = 'full',
      swap_fields = false,
      swap_icons = false,
    },
    idle = {
      enabled = false,
    },
    buttons = {
      {
        label = 'View Repository',
        url = function(opts) return opts.repo_url end,
      },
      {
        label = 'View Icon Theme',
        url = 'https://github.com/funcfusion/mc-dp-icons',
      }
    },
    extensions = {
      resolver = {
        sources = {
          oil = true,
        },
      },
    },
  },
}
