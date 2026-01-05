return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { Harpoon = "󱡀" } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>h"
        maps.n[prefix] = { desc = require("astroui").get_icon("Harpoon", 1, true) .. "Harpoon" }

        maps.n["<A-J>"] = { function() require("harpoon"):list():select(1) end, desc = "Select mark 1" }
        maps.n["<A-K>"] = { function() require("harpoon"):list():select(2) end, desc = "Select mark 2" }
        maps.n["<A-L>"] = { function() require("harpoon"):list():select(3) end, desc = "Select mark 3" }
        maps.n["<A-:>"] = { function() require("harpoon"):list():select(4) end, desc = "Select mark 4" }

        maps.n[prefix .. "f"] = { function() require("harpoon"):list():add() end, desc = "Add file" }
        maps.n[prefix .. "d"] = {
          function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
          desc = "Toggle quick menu",
        }
        maps.n[prefix .. "s"] = {
          function()
            vim.ui.input({ prompt = "Harpoon mark index: " }, function(input)
              local num = tonumber(input)
              if num then require("harpoon"):list():select(num) end
            end)
          end,
          desc = "Goto index of mark",
        }
        maps.n["<C-p>"] = { function() require("harpoon"):list():prev() end, desc = "Goto previous mark" }
        maps.n["<C-n>"] = { function() require("harpoon"):list():next() end, desc = "Goto next mark" }
      end,
    },
  },
}
