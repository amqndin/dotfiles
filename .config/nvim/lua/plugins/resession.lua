return {
  "stevearc/resession.nvim",
  lazy = true,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>s"] = vim.tbl_get(opts, "_map_sections", "S")
        maps.n["<Leader>sl"] = { function() require("resession").load "Last Session" end, desc = "Load last session" }
        maps.n["<Leader>ss"] = {
          function() require("resession").save(vim.fn.getcwd(), { dir = "dirsession" }) end,
          desc = "Save this dirsession",
        }
        maps.n["<Leader>sd"] =
          { function() require("resession").delete(nil, { dir = "dirsession" }) end, desc = "Delete a dirsession" }
        maps.n["<Leader>sf"] =
          { function() require("resession").load(nil, { dir = "dirsession" }) end, desc = "Load a dirsession" }
        maps.n["<Leader>s."] = {
          function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
          desc = "Load current dirsession",
        }
      end,
    },
  },
}
