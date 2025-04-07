-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
local _guifont = "JetBrainsMonoNL Nerd Font Mono:h13:w0"
if vim.g.neovide then _guifont = "JetBrainsMono Nerd Font:h12.5:w0" end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = { -- vim.<key>
      opt = {
        langmap = "йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ;qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'\\\"zZxXcCvVbBnNmM\\,<.>",
        relativenumber = true,
        signcolumn = "yes",
        sidescrolloff = 10,
        timeout = false,
        scrolloff = 8,
        cmdheight = 1,
        number = true,
        spell = false,
        wrap = false,
        mouse = "",
        showbreak = "↳ ",
      },
      g = {
        neovide_no_idle = true,
      },
      o = {
        guifont = _guifont,
      },
    },
    commands = {
      open_messages = {
        function()
          local scratch_buffer = vim.api.nvim_create_buf(false, true)
          vim.bo[scratch_buffer].filetype = 'vim'
          local messages = vim.split(vim.fn.execute('messages', 'silent'), '\n')
          vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
          vim.cmd('vertical sbuffer ' .. scratch_buffer)
          vim.opt_local.wrap = true
          vim.bo.buflisted = false
          vim.bo.bufhidden = 'wipe'
          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = scratch_buffer })
        end
      }
    },
    filetypes = {
      extension = {
        png = "image",
        svg = "image",
        jpg = "image",
        jpeg = "image",
        mcfunction = "mcfunction",
        svx = "markdown",
        mcmeta = "json",
        bolt = "bolt",
        jmc = "jmc",
        hjmc = "hjmc",
      },
    },
    autocmds = {
      mcfunction_commentstring = {
        {
          event = "FileType",
          pattern = "mcfunction",
          callback = function() vim.opt.commentstring = "# %s" end,
        },
      },
      markdown_wrap = {
        {
          event = "FileType",
          callback = function()
            if vim.bo.filetype == "markdown" then
              vim.opt.wrap = true
            else
              vim.opt.wrap = false
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
