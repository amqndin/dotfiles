return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>e"] = { function() require("oil").toggle_float() end, desc = "Open folder in Oil" },
          },
        },
        autocmds = {
          oil_settings = {
            {
              event = "FileType",
              desc = "Disable view saving for oil buffers",
              pattern = "oil",
              callback = function(args) vim.b[args.buf].view_activated = false end,
            },
            {
              event = "User",
              pattern = "OilActionsPost",
              desc = "Close buffers when files are deleted in Oil",
              callback = function(args)
                if args.data.err then return end
                for _, action in ipairs(args.data.actions) do
                  if action.type == "delete" then
                    local _, path = require("oil.util").parse_url(action.url)
                    local bufnr = vim.fn.bufnr(path)
                    if bufnr ~= -1 then require("astrocore.buffer").wipe(bufnr, true) end
                  end
                end
              end,
            },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      optional = true,
      dependencies = { "AstroNvim/astroui", opts = { status = { winbar = { enabled = { filetype = { "^oil$" } } } } } },
      opts = function(_, opts)
        if opts.winbar then
          local status = require "astroui.status"
          table.insert(opts.winbar, 1, {
            condition = function(self) return status.condition.buffer_matches({ filetype = "^oil$" }, self.bufnr) end,
            status.component.separated_path {
              padding = { left = 2 },
              max_depth = false,
              suffix = false,
              path_func = function(self) return require("oil").get_current_dir(self.bufnr) end,
            },
          })
        end
      end,
    },
  },
  opts = function()
    local get_icon = require("astroui").get_icon
    local config = {}

    config = {
      delete_to_trash = true,
      columns = {
        {
          "icon",
          default_file = get_icon "DefaultFile",
          directory = get_icon "FolderClosed",
        },
      },
      keymaps = {
        ["<S-h>"] = "actions.parent",
        ["<S-l>"] = "actions.select",
        ["g,"] = "actions.toggle_trash",
      },
      skip_confirm_for_simple_edits = true,
    }

    return config
  end,
}
