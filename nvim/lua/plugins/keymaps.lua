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
    local vcount = vim.v.count

    -- switch between buffers
    map.n["L"] = {
      function() buffer.nav(vcount > 0 and vcount or 1) end,
      desc = "Next buffer",
    }
    map.n["H"] = {
      function() buffer.nav(-(vcount > 0 and vcount or 1)) end,
      desc = "Previous buffer",
    }

    -- terminal maps
    for _, mode in ipairs { "t", "i", "n" } do
      map[mode]["<F7>"] = false
    end

    map.i["<A-j>"] = { "<Esc><Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }
    map.t["<A-j>"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }
    map.n["<A-j>"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" }

    map.t["<S-Space>"] = { function() switch_terminal_mode() end, desc = "Switch terminal mode" }
    map.n["<S-Space>"] = { function() switch_terminal_mode() end, desc = "Switch terminal mode" }

    -- convenience maps
    map.x["g/"] = { "<Esc>/\\%V", desc = "Search within selection" }
    map.n["<Leader>um"] = { "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" }

    map.i["<C-BS>"] = { "<C-w>", desc = "Delete word" }
    map.c["<C-BS>"] = { "<C-w>", desc = "Delete word" }
    map.t["<C-BS>"] = { "<C-w>", desc = "Delete word" }

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

    -- add more text objects for "in" and "around"
    for _, char in ipairs { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?", "$" } do
      for _, mode in ipairs { "x", "o" } do
        map[mode]["i" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%slvt%s<CR>", char, char, char),
          desc = "between " .. char,
        }
        map[mode]["a" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%svf%s<CR>", char, char, char),
          desc = "around " .. char,
        }
      end
    end
  end,
}
