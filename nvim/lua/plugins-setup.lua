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
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "go", "cpp", "python", "java", "sql", "bash", "typescript", "dockerfile", "yaml" },
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
        dependencies = { 'nvim-lua/plenary.nvim' },
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
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            variant = "auto", -- auto
            dark_variant = "main",
            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },

            groups = {
                border = "muted",
                link = "iris",
                panel = "surface",

                error = "love",
                hint = "iris",
                info = "foam",
                note = "pine",
                todo = "rose",
                warn = "gold",

                git_add = "foam",
                git_change = "rose",
                git_delete = "love",
                git_dirty = "rose",
                git_ignore = "muted",
                git_merge = "iris",
                git_rename = "pine",
                git_stage = "iris",
                git_text = "rose",
                git_untracked = "subtle",

                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },

            palette = {
                -- Override the builtin palette per variant
                -- moon = {
                    --     base = '#18191a',
                    --     overlay = '#363738',
                    -- },
                },

                highlight_groups = {
                    -- Comment = { fg = "foam" },
                    -- VertSplit = { fg = "muted", bg = "muted" },
                },

                before_highlight = function(group, highlight, palette)
                    -- Disable all undercurls
                    -- if highlight.undercurl then
                    --     highlight.undercurl = false
                    -- end
                    --
                    -- Change palette colour
                    -- if highlight.fg == palette.pine then
                    --     highlight.fg = palette.foam
                    -- end
                end,
            },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'windwp/nvim-ts-autotag',
    },
    {
        'mbbill/undotree',
    },
})

-- Set theme
vim.cmd("colorscheme rose-pine-main")
-- Set background transparency -- CONFLICT WITH rose-pine
-- vim.cmd[[highlight Normal guibg=NONE ctermbg=NONE]]
-- vim.cmd[[highlight NonText guibg=NONE ctermbg=NONE]]
-- vim.cmd[[highlight SignColumn guibg=NONE ctermbg=NONE]]
-- vim.cmd[[highlight EndOfBuffer guibg=NONE ctermbg=NONE]]

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
    ensure_installed = {"gopls", "clangd", "pyright", "lua_ls", "jdtls", "ts_ls", "cssls", "html", "sqlls", "docker_compose_language_service", "dockerls", "nginx_language_server", "tailwindcss", "yamlls"},
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
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
require("lspconfig").sqlls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").docker_compose_language_service.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").dockerls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").nginx_language_server.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").tailwindcss.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
require("lspconfig").yamlls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'horizon', -- auto
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = true
    }
  }
})
