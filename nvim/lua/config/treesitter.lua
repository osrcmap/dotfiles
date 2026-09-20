local M = {}

M.parsers = {
  "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "go", "cpp",
  "python", "java", "sql", "bash", "typescript", "tsx", "dockerfile", "yaml",
  "json", "markdown", "markdown_inline",
}

function M.setup()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

  local function attach(buf)
    if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= "" then
      return
    end
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang or not vim.treesitter.language.add(lang) then
      return -- Keep normal syntax/indentation for filetypes without a parser.
    end
    vim.treesitter.start(buf, lang)
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
    callback = function(args) attach(args.buf) end,
  })

  -- Installation is asynchronous; also activate buffers opened while it ran.
  treesitter.install(M.parsers):await(vim.schedule_wrap(function(err)
    if err then
      vim.notify(tostring(err), vim.log.levels.ERROR)
      return
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      attach(buf)
    end
  end))
end

return M
