-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "typescript",
      "c",
      -- add more arguments for adding more treesitter parsers
    })

    opts.indent = require("astrocore").extend_tbl(opts.indent, {
      disable = { "javascript" },
    })

    vim.treesitter.language.register("javascript", "jmc")
    vim.treesitter.language.register("swift", "rn")
    vim.treesitter.language.register("swift", "ramen")
    vim.treesitter.language.register("c", "hjmc")
    vim.treesitter.language.register("python", "bolt")
  end,
}
