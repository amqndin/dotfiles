return {
  {
    "amqndin/vim-bolt-highlight", opts = {}
  },
  {
    "bbfh-dev/tree-sitter-mcfunction",
    enabled = false,
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
        },
      })
    end,
  }
}
