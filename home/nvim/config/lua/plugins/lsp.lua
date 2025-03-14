local function setup_typst_preview()
    require('typst-preview').setup {
        open_cmd = 'firefox --new-window %s',

        dependencies_bin = {
            ['tinymist'] = '/usr/bin/tinymist', -- FIXME
            ['websocat'] = '/usr/bin/websocat', -- FIXME
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
        ['__default__'] = function(server)
            lspconfig[server.name].setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = { server.path },
            }
        end,

        ['jdtls'] = function(server)
            local server_config = lspconfig[server.name]
            local cmd = server_config.config_def.default_config.cmd
            cmd[1] = server.path

            server_config.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = cmd,
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

        ['rust_analyzer'] = function(server)
            -- Export env vars
            local vars_to_export =
                { 'PATH', 'LD_LIBRARY_PATH', 'PKG_CONFIG_PATH' }
            local cmd = ''
            for _, env_name in ipairs(vars_to_export) do
                local env_val = os.getenv(env_name)
                if env_val ~= nil then
                    env_val = env_val:gsub("'", "\\'")
                    cmd = cmd .. env_name .. "='" .. env_val .. "' "
                end
            end
            cmd = cmd .. server.name

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

            -- lspMux
            settings.lspMux = {
                version = '1',
                method = 'connect',

                -- I'm using this workarround as ra-multiplex's `pass_environment` don't work.
                -- It seems that the PATH are not used when looking for `cargo` and `rustc` executables.
                server = '/bin/sh',
                args = { '-c', cmd },
            }

            lspconfig.rust_analyzer.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = vim.lsp.rpc.connect('127.0.0.1', 27631),
                settings = {
                    ['rust-analyzer'] = settings,
                },
            }
        end,

        ['lua_ls'] = function(server)
            lspconfig.lua_ls.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = { server.path },

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

        ['tinymist'] = function(server)
            lspconfig.tinymist.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = { server.path },
                settings = {
                    exportPdf = 'onType',
                    outputPath = '$name',
                },
            }
        end,
    }

    for _, lang_data in pairs(LangCfg) do
        local server = lang_data.server

        if server ~= nil then
            local cfg = server_config[server.name]
            if cfg == nil then
                server_config['__default__'](server)
            else
                cfg(server)
            end
        end
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
