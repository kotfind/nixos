local function setup_typst_preview()
    require('typst-preview').setup {
        open_cmd = 'firefox --new-window %s',

        dependencies_bin = {
            ['tinymist'] = 'tinymist',
            ['websocat'] = 'websocat',
        },

        get_main_file = function(bufpath)
            if vim.fn.filereadable 'main.typ' then
                return 'main.typ'
            else
                return bufpath
            end
        end,
    }
end

local function on_attach(client, bufnr)
    -- Disable lsp highlighting for typst (it's broken)
    if vim.bo.filetype == 'typst' then
        client.server_capabilities.semanticTokensProvider = nil
    end

    -- Buffer Mappings
    local function bmap(modes, key, func)
        Map(modes, key, func, {
            noremap = true,
            silent = true,
            buffer = bufnr,
        })
    end

    bmap('n', 'gD', vim.lsp.buf.declaration)
    bmap('n', 'gd', vim.lsp.buf.definition)
    bmap('n', 'gi', vim.lsp.buf.implementation)

    bmap('n', 'K', vim.lsp.buf.hover)
    bmap('n', 'L', vim.lsp.buf.signature_help)

    bmap('n', '<leader>lr', vim.lsp.buf.rename)
    bmap({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action)
    bmap('n', '<leader>lR', vim.lsp.buf.references)
end

local function capabilities()
    return require('cmp_nvim_lsp').default_capabilities()
end

local function setup_diagnostics()
    vim.diagnostic.config {
        -- disable built-in diagnostics display
        virtual_text = false,

        -- disable lsp_lines at start
        virtual_lines = false,
    }

    vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = false,
            severity_sort = true,
        })

    local lsp_lines = require 'lsp_lines'
    lsp_lines.setup {}
    Map('n', '<leader>tl', lsp_lines.toggle)
end

local function setup_servers()
    local lspconfig = require 'lspconfig'
    local util = require 'lspconfig.util'

    -- LSP Confi docs:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    local server_config = {
        ['__default__'] = function()
            return {
                on_attach = on_attach,
                capabilities = capabilities(),
            }
        end,

        ['jdtls'] = function()
            return {
                on_attach = on_attach,
                capabilities = capabilities(),
                settings = {
                    java = {
                        import = {
                            gradle = {
                                enabled = true,
                            },
                        },
                        format = {
                            enabled = false,
                        },
                    },
                },
            }
        end,

        ['rust_analyzer'] = function()
            -- Common settings
            --
            -- List of all options:
            -- https://rust-analyzer.github.io/book/configuration.html
            local settings = {
                allTargets = true,

                check = {
                    command = 'clippy',
                },

                diagnostics = {
                    disabled = { 'dead_code', 'unused_variables' },
                },

                cargo = {
                    targetDir = true,
                    features = 'all',
                },
            }

            return {
                on_attach = on_attach,
                capabilities = capabilities(),
                settings = {
                    ['rust-analyzer'] = settings,
                },
            }
        end,

        ['lua_ls'] = function()
            return {
                on_attach = on_attach,
                capabilities = capabilities(),

                root_dir = util.root_pattern { '.git' },

                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                'vim',
                                's',
                                't',
                                'i',
                                'f',
                                'd',
                                'r',
                                'sn',
                                'fmt',
                                'fmta',
                                'rep',
                                'k',
                                'c',
                            },
                        },
                    },
                },
            }
        end,

        ['tinymist'] = function()
            return {
                on_attach = on_attach,
                capabilities = capabilities(),
                settings = {
                    exportPdf = 'onType',
                    outputPath = '$name',
                },
            }
        end,
    }

    local server_list = {
        'pyright',
        'ccls',
        'rust_analyzer',
        'lua_ls',
        'tinymist',
        'bashls',
        'jdtls',
        'nixd',
        'dotls',
    }

    for _, server_name in pairs(server_list) do
        local cfg = server_config[server_name]
        if cfg == nil then
            cfg = server_config['__default__']
        end

        lspconfig[server_name].setup(cfg())
    end
end

local function setup_lsp()
    -- Mappings
    Map('n', '[d', vim.diagnostic.goto_prev)
    Map('n', ']d', vim.diagnostic.goto_next)
    Map('n', '<leader>ld', vim.diagnostic.open_float)
    Map('n', '<leader>lD', vim.diagnostic.setloclist)

    -- Setup servers
    setup_servers()
end

return {
    {
        'neovim/nvim-lspconfig',
        config = setup_lsp,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        },
    },

    {
        'j-hui/fidget.nvim',
        main = 'fidget',
        opts = {},
    },

    {
        url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = setup_diagnostics,
    },

    {
        'stevearc/dressing.nvim',
        main = 'dressing',
        opts = {},
    },

    {
        'chomosuke/typst-preview.nvim',
        config = setup_typst_preview,
    },
}
