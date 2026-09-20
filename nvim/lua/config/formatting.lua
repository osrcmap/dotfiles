local M = {}

function M.setup()
  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "gofmt" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = function(buf)
      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat or vim.bo[buf].buftype ~= "" then
        return
      end
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
  })

  -- Available even when no language server is attached (e.g. Python/Markdown).
  vim.keymap.set({ "n", "x" }, "<leader>f", function()
    conform.format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format buffer or selection" })

  vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, { bang = true, desc = "Disable format on save (! for current buffer)" })
  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.g.disable_autoformat = false
    vim.b.disable_autoformat = false
  end, { desc = "Enable format on save" })
end

return M
