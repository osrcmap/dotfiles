local M = {}

function M.setup()
  require("gitsigns").setup({
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(mode, key, action, desc)
        vim.keymap.set(mode, key, action, { buffer = buf, desc = desc })
      end
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Git change")
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Previous Git change")
      map("n", "<leader>hs", gs.stage_hunk, "Stage/unstage Git hunk")
      map("x", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected Git lines")
      map("n", "<leader>hp", gs.preview_hunk, "Preview Git hunk")
      map("n", "<leader>hb", gs.blame_line, "Blame current line")
      map("n", "<leader>hd", gs.diffthis, "Diff against Git index")
      map({ "o", "x" }, "ih", gs.select_hunk, "Select Git hunk")
    end,
  })
end

return M
