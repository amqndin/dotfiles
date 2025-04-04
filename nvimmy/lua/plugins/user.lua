-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  {
    "catppuccin",
    opts = { term_colors = true },
  },
  { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
  { "CrystalAlpha358/vim-mcfunction", ft = { "mcfunction" } },
  {
    "echasnovski/mini.splitjoin",
    keys = { { "gs", mode = { "n", "v" } } },
    opts = { mappings = { toggle = "gs" } },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { render_modes = { "n", "c", "t", "i" } },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "User AstroFile",
    opts = {
      keymaps = {
        accept_suggestion = "<A-y>",
        clear_suggestion = "<C-h>",
        accept_word = "<C-l>",
      },
      ignore_filetypes = { "markdown", "neo-tree-popup" },
    },
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },
}
