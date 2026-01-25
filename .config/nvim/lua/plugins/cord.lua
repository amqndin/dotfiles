local blacklist = { }

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
    log_level = vim.log.levels.INFO,
    editor = {
      client = 'neovim',
      tooltip = 'The Superior Text Editor',
      icon = nil,
    },
    display = {
      theme = 'minecraft',
      flavor = 'accent',
      view = 'full',
      swap_fields = false,
      swap_icons = false,
    },
    timestamp = {
      enabled = true,
      reset_on_idle = false,
      reset_on_change = false,
      shared = false,
    },
    idle = {
      enabled = true,
      timeout = 300000,
      show_status = true,
      ignore_focus = true,
      unidle_on_focus = true,
      smart_idle = true,
      details = 'Idling',
      state = nil,
      tooltip = '💤',
      icon = nil,
    },
    text = {
      default = nil,
      workspace = function(opts)
        return is_blacklisted(opts) and "In a secret workspace" or ("In " .. opts.workspace)
      end,
      viewing = function(opts) return 'Viewing ' .. opts.filename end,
      editing = function(opts) return 'Editing ' .. opts.filename end,
      file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
      plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
      lsp = function(opts) return 'Configuring LSP in ' .. opts.name end,
      docs = function(opts) return 'Reading ' .. opts.name end,
      vcs = function(opts) return 'Committing changes in ' .. opts.name end,
      notes = function(opts) return 'Taking notes in ' .. opts.name end,
      debug = function(opts) return 'Debugging in ' .. opts.name end,
      test = function(opts) return 'Testing in ' .. opts.name end,
      diagnostics = function(opts) return 'Fixing problems in ' .. opts.name end,
      games = function(opts) return 'Playing ' .. opts.name end,
      terminal = function(opts) return 'Executing in ' .. opts.name end,
      dashboard = 'Home',
    },
    buttons = {
      {
        label = 'View Repository',
        url = function(opts) return opts.repo_url end,
      },
    },
    hooks = {
      pre_activity = function(opts)
        if opts.filetype == 'toggleterm' then
          local ft = opts.filename:match '^%d+:([^%s;]+)'
          if ft and ft ~= '' then opts.force_filetype = ft end
        end
      end,
    },
    -- assets = {
    --   jmc = {
    --     type = "language",
    --     name = "JMC",
    --     icon = "https://github.com/amqndin/dotfiles/blob/main/.config/nvim/assets/presence/jmc.png?raw=true",
    --     tooltip = "JMC",
    --   },
    --   mcfunction = {
    --     type = "language",
    --     name = "MCFunction",
    --     icon = "https://github.com/amqndin/dotfiles/blob/main/.config/nvim/assets/presence/mcfunction.png?raw=true",
    --     tooltip = "MCFunction",
    --   },
    -- },
    plugins = nil,
  },
}
