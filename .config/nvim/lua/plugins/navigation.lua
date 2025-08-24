local hop_mappings = {
  ["s"] = { "<cmd>HopChar1<CR>", desc = "Hop to a specific character" },
  ["<S-s>"] = { "<cmd>HopLine<CR>", desc = "Hop to a specific line" },
}

return {
  {
    "theprimeagen/harpoon",
    dependencies = {
      {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
          mappings = {
            n = {
              ["<a-u>"] = { "<cmd>lua require('harpoon'):list():select(1)<CR>" },
              ["<a-i>"] = { "<cmd>lua require('harpoon'):list():select(2)<CR>" },
              ["<a-o>"] = { "<cmd>lua require('harpoon'):list():select(3)<CR>" },
              ["<a-p>"] = { "<cmd>lua require('harpoon'):list():select(4)<CR>" },
              ["<C-x>"] = false,
            },
          },
        },
      },
    },
    opts = {},
    event = "User AstroFile",
  },
  {
    "smoka7/hop.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
          mappings = {
            v = hop_mappings,
            n = hop_mappings,
            o = hop_mappings,
          },
        },
      },
    },
    opts = { keys = "etovxqpdygfblzhckisuran" },
    event = "User AstroFile",
  },
}
