function LspExec(command, ...)
    local function handler(results)
        for _, result in ipairs(results) do
            if result.error ~= nil then
                error("failed to execute comand '" .. command .. "': " .. result.error.message)
            end
        end
    end

    vim.lsp.buf_request_all(
        0,
        'workspace/executeCommand',
        {
            command = command,
            arguments = { ... },
        },
        handler
    )
end

local function setup_typst_preview()
    require 'typst-preview'.setup {
        open_cmd = 'firefox --new-window %s',

        dependencies_bin = {
            ['tinymist'] = vim.fn.stdpath('data') .. '/mason/bin/tinymist',
            ['websocat'] = '/usr/bin/websocat',
        },

        get_main_file = function(bufpath)
            if vim.fn.filereadable('main.typ') then
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
            buffer = bufnr
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
    return require 'cmp_nvim_lsp'.default_capabilities()
end

local function setup_diagnostics()
    vim.diagnostic.config {
        -- disable built-in diagnostics display
        virtual_text = false,

        -- disable lsp_lines at start
        virtual_lines = false,
    }

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        severity_sort = true,
    })

    local lsp_lines = require 'lsp_lines'
    lsp_lines.setup {}

    Map('n', '<leader>tl', lsp_lines.toggle)
end

local function setup_lspconfig()
    local lspconfig = require 'lspconfig'

    local server_config = {
        ['__default__'] = function(server_name)
            lspconfig[server_name].setup {
                on_attach = on_attach,
                capabilities = capabilities(),
            }
        end,

        ['rust_analyzer'] = function()
            local vars_to_export = { 'PATH', 'LD_LIBRARY_PATH' }
            local exec_name = '';
            for _, var in ipairs(vars_to_export) do
                exec_name = exec_name .. var .. '=' .. os.getenv(var) .. ' '
            end
            exec_name = exec_name .. 'rust-analyzer'

            lspconfig.rust_analyzer.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = vim.lsp.rpc.connect('127.0.0.1', 27631),
                settings = {
                    ["rust-analyzer"] = {
                        lspMux = {
                            version = '1',
                            method = 'connect',

                            -- I'm using this workarround as ra-multiplex's `pass_environment` don't work.
                            -- It seems that the PATH are not used when looking for `cargo` and `rustc` executables.
                            server = '/bin/sh',
                            args = { '-c', exec_name },
                        },

                        -- All options: https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        checkOnSave = {
                            command = 'clippy',
                        },
                        allTargets = true,
                    },
                }
            }
        end,

        ['lua_ls'] = function()
            lspconfig.lua_ls.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim', 's', 't', 'i', 'f', 'd', 'r', 'sn', 'fmt', 'fmta', 'rep', 'k', 'c' },
                        },
                    },
                },
            }
        end,

        ['java_language_server'] = function()
            lspconfig.java_language_server.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                cmd = { 'java-language-server' },
            }
        end,

        ['tinymist'] = function()
            lspconfig.tinymist.setup {
                on_attach = on_attach,
                capabilities = capabilities(),
                settings = {
                    exportPdf = 'onType',
                    outputPath = '$name',
                }
            }
        end
    }

    for _, server_name in ipairs(LspServerNames) do
        local cfg = server_config[server_name]
        if cfg == nil then
            server_config['__default__'](server_name)
        else
            cfg()
        end
    end
end

local function setup_lsp()
    -- Mappings
    Map('n', '[d', vim.diagnostic.goto_prev)
    Map('n', ']d', vim.diagnostic.goto_next)
    Map('n', '<leader>ld', vim.diagnostic.open_float)
    Map('n', '<leader>lD', vim.diagnostic.setloclist)

    -- Format on save
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        callback = function()
            if vim.bo.filetype ~= 'cpp' and vim.bo.filetype ~= 'c' and vim.bo.filetype ~= 'kotlin' then
                vim.lsp.buf.format()
            end
        end
    })

    -- Setup servers
    setup_lspconfig()
end

return {
    {
        'neovim/nvim-lspconfig',
        config = setup_lsp,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
        }
    },

    {
        'j-hui/fidget.nvim',
        main = 'fidget',
        opts = {},
    },

    {
        url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = setup_diagnostics
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
