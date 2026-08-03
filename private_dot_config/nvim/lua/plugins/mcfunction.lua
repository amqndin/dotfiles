return {
  -- {
  --   "amqndin/vim-bolt-highlight",
  --   ft = { "bolt", "mcfunction" },
  --   opts = {}
  -- },
  {
    "bbfh-dev/tree-sitter-mcfunction",
    enabled = true,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").mcfunction = {
            install_info = {
              url = "https://github.com/bbfh-dev/tree-sitter-mcfunction",
              files = { "src/parser.c" },
              branch = "main",
              queries = "queries/mcfunction",
            },
          }
        end,
      })

      vim.filetype.add({
        extension = {
          mcfunction = "mcfunction",
          bolt = "bolt",
        },
      })

      -- vim.treesitter.language.register("mcfunction", "bolt")
    end,
  }
  -- {
  --   dir = "/home/amandin/src/lab/vim-mcfunction-highlighter",
  --   ft = { "bolt", "mcfunction" },
  --   opts = {}
  -- },
}
