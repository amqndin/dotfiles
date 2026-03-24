local function switch_terminal_mode()
  if vim.bo.buftype == "terminal" then vim.cmd(vim.fn.mode() == "n" and "startinsert" or "stopinsert") end
end

local function move_to_paragraph(direction)
  local current_line = vim.fn.line "."
  local search_flags = direction == "next" and "n" or "bn"
  local next_line = vim.fn.search("^\\s*$", search_flags) or 0
  if (direction == "next" and current_line >= next_line) or (direction == "prev" and current_line <= next_line) then
    vim.cmd("norm! " .. (direction == "next" and "G" or "gg"))
  else
    vim.fn.search("^\\s*$", direction == "next" and "" or "b")
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(
    _,
    opts --[[@as AstroCoreOpts]]
  )
    local map = opts.mappings
    local buffer = require "astrocore.buffer"
    local vcount = vim.v.count1

    -- switch between buffers
    map.n["L"] = { function() buffer.nav(vcount) end, desc = "Next buffer" }
    map.n["H"] = { function() buffer.nav(-vcount) end, desc = "Previous buffer" }

    -- terminal 
    for _, mode in ipairs { "t", "i", "n" } do
      map[mode]["<F7>"] = false
    end

    map.i["<A-j>"] = { "<Esc><Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }
    map.t["<A-j>"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }
    map.n["<A-j>"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }

    map.n["<Leader>ts"] = { "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle horizontal terminal" }
    map.n["<Leader>tv"] = { "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" }

    map.t["<A-k>"] = { function() switch_terminal_mode() end, desc = "Switch terminal mode" }
    map.n["<A-k>"] = { function() switch_terminal_mode() end, desc = "Switch terminal mode" }

    -- fun stuff
    map.n["о"] = { "gj" }
    map.n["л"] = { "gk" }
    map.n["<Leader>um"] = { "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" }
    map.x["g/"] = { "<Esc>/\\%V", desc = "Search within selection" }

    map.n["<Leader>Ml"] = { "<Cmd>OverseerLoadBundle<CR>", desc = "Load bundle" }

    for _, mode in ipairs { "t", "i", "c" } do
      map[mode]["<C-BS>"] = { "<C-w>", desc = "Delete word" }
    end

    map.c["<C-j>"] = { "<C-n>", desc = "Select next item", remap = true }
    map.c["<C-k>"] = { "<C-p>", desc = "Select previous item", remap = true }

    for _, mode in ipairs { "n", "x", "v", "o" } do
      map[mode]["}"] = { function() move_to_paragraph "next" end, desc = "Move to next paragraph" }
      map[mode]["{"] = { function() move_to_paragraph "prev" end, desc = "Move to previous paragraph" }
    end

    map.x["@"] = {
      function() return ":norm @" .. vim.fn.getcharstr() .. "<cr>" end,
      desc = "Repeat macros across visual selection",
      silent = false,
      expr = true,
    }

    map.n["<Leader>."] = { ":lcd %:p:h<CR>", desc = "CD to current file" }
    map.n["G"] = { "Gzz", desc = "Scroll to bottom" }
    map.x["<"] = { "<gv", desc = "Deindent line" }
    map.x[">"] = { ">gv", desc = "Indent line" }

    map.n["<Leader>fn"] = { function() require("snacks").notifier.show_history() end, desc = "Notifications" }

    -- add more text objects for "in" and "around"
    for _, char in ipairs { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?", "$" } do
      for _, mode in ipairs { "x", "o" } do
        map[mode]["i" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%slvt%s<CR>", char, char, char),
          desc = "between " .. char,
        }
        map[mode]["a" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%slvf%s<CR>", char, char, char),
          desc = "around " .. char,
        }
      end
    end
  end,
}
