local blacklist = {
  "antbot",
}

local function is_blacklisted(opts)
  for _, workspace in ipairs(blacklist) do
    if string.find(opts.workspace, workspace) then return true end
  end
  return false
end

return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  opts = {
    enabled = true,
    log_level = vim.log.levels.OFF,
    editor = {
      client = "neovim",
      tooltip = "The Superior Text Editor",
      icon = nil,
    },
    display = {
      theme = "default",
      flavor = "accent",
      swap_fields = false,
      swap_icons = false,
    },
    text = {
      viewing = function(opts) return is_blacklisted(opts) and "Viewing a file" or ("Viewing " .. opts.filename) end,
      workspace = function(opts)
        return is_blacklisted(opts) and "In a secret workspace" or ("Working on " .. opts.workspace)
      end,
      editing = function(opts) return is_blacklisted(opts) and "Editing a file" or ("Editing " .. opts.filename) end,
      file_browser = function(opts) return "Browsing files in " .. opts.name end,
      plugin_manager = function(opts) return "Managing plugins in " .. opts.name end,
      lsp = function(opts) return "Configuring LSP in " .. opts.name end,
      docs = function(opts) return "Reading " .. opts.name end,
      vcs = function(opts) return "Committing changes in " .. opts.name end,
      notes = function(opts) return "Taking notes in " .. opts.name end,
      debug = function(opts) return "Debugging in " .. opts.name end,
      test = function(opts) return "Testing in " .. opts.name end,
      diagnostics = function(opts) return "Fixing problems in " .. opts.name end,
      games = function(opts) return "Playing " .. opts.name end,
      terminal = function(opts) return "Running commands in " .. opts.name end,
      dashboard = "Home",
    },
    assets = {
      jmc = {
        name = "JMC",
        icon = "https://github.com/amqndin/nvim/blob/main/assets/presence/jmc.png?raw=true",
        tooltip = "JMC",
      },
      mcfunction = {
        name = "MCFunction",
        icon = "https://github.com/amqndin/nvim/blob/main/assets/presence/mcfunction.png?raw=true",
        tooltip = "MCFunction",
      },
    },
  },
}
