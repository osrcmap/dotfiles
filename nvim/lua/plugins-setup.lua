local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "go", "cpp", "python", "java", "sql", "bash", "typescript" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        }
    }
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup{
    ensure_installed = {"gopls", "clangd", "pyright", "lua_ls", "jdtls", "ts_ls", "cssls", "html"},
}

-- cmp config
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Function to configure key mappings after the LSP attaches to a buffer
local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Key mappings for LSP utilities
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)           -- Go to definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)          -- Go to declaration
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                 -- Hover documentation
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)       -- Go to implementation
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)           -- List references
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)       -- Rename symbol
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)  -- Show code actions
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts) -- Format code

    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)    -- Show diagnostics in a floating window
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)            -- Go to previous diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)            -- Go to next diagnostic
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)    -- Set location list

end

require("lspconfig").gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").clangd.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").lua_ls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").jdtls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").ts_ls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").cssls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").html.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
