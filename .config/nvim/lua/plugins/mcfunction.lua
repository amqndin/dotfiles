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

      vim.treesitter.language.register("mcfunction", "bolt")

      local keyword_caps = {
        "keyword", "keyword.function", "keyword.return", "keyword.conditional",
        "keyword.repeat", "keyword.operator", "keyword.directive",
        "keyword.import", "keyword.exception", "keyword.type",
        "keyword.modifier", "keyword.storage",
      }

      local function no_italic(name)
        local hl = vim.api.nvim_get_hl(0, { name = name })
        if not hl then return end
        while hl.link do
          local next = vim.api.nvim_get_hl(0, { name = hl.link })
          if not next then break end
          hl = next
        end
        hl.italic = false
        vim.api.nvim_set_hl(0, name, hl)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("BoltNoItalic", { clear = true }),
        pattern = { "mcfunction", "bolt" },
        once = true,
        callback = function()
          vim.schedule(function()
            for _, cap in ipairs(keyword_caps) do
              no_italic("@" .. cap)
            end
          end)
        end,
      })
    end,
  }
  -- {
  --   dir = "/home/amandin/src/lab/vim-mcfunction-highlighter",
  --   ft = { "bolt", "mcfunction" },
  --   opts = {}
  -- },
}
