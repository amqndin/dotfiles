return {
  "cbochs/grapple.nvim",
  opts = {
    scope = "git_branch",
    icons = true,
    status = false,
  },
  keys = {
    { "<leader>jf", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
    { "<leader>jd", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
    { "<leader>js", "<cmd>Grapple reset<cr>", desc = "Reset all tags" },

    { "<A-J>", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
    { "<A-K>", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
    { "<A-L>", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
    { "<A-:>", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

    { "<leader>jj", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
    { "<leader>jk", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
  },
}

-- vim: ts=2 sts=2 sw=2 et
