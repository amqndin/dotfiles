---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      jmc_commentstring = {
        {
          event = "FileType",
          pattern = "jmc",
          callback = function() vim.opt.commentstring = "// %s" end,
        },
      },
      mcfunction_commentstring = {
        {
          event = "FileType",
          pattern = "mcfunction",
          callback = function() vim.opt.commentstring = "# %s" end,
        },
      },
      markdown_file = {
        {
          event = "FileType",
          pattern = "markdown",
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.textwidth = 0
          end,
        },
      },
      chafa_image = {
        {
          event = "BufEnter",
          callback = function()
            if vim.bo.filetype == "image" then
              require("snacks.indent").disable()
            else
              require("snacks.indent").enable()
            end
          end,
        },
      },
      add_directory_to_zoxide = {
        {
          event = "DirChanged",
          callback = function(data)
            local dir = data.file
            vim.system { "zoxide", "add", dir }
            print("Added " .. dir .. " to zoxide")
          end,
        },
      },
    },
  },
}
