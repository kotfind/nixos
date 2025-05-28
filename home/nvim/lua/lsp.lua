local M = {}

---@param client vim.lsp.Client
---@param bufnr integer
---@return nil
local function on_attach(client, bufnr)
    -- buffer mappings
    local function bmap(modes, key, func)
        Map(modes, key, func, {
            noremap = true,
            silent = true,
            buffer = bufnr,
        })
    end

    -- go to
    bmap('n', 'gD', vim.lsp.buf.declaration)
    bmap('n', 'gd', vim.lsp.buf.definition)
    bmap('n', 'gi', vim.lsp.buf.implementation)

    -- show info
    bmap('n', 'K', vim.lsp.buf.hover)
    bmap('n', 'L', vim.lsp.buf.signature_help)

    -- workspace folders
    bmap('n', '<leader>lfa', vim.lsp.buf.add_workspace_folder)
    bmap('n', '<leader>lfr', vim.lsp.buf.remove_workspace_folder)

    -- other
    bmap('n', '<leader>lr', vim.lsp.buf.rename)
    bmap('n', '<leader>lR', vim.lsp.buf.references)
    bmap({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action)
    bmap({ 'n', 'x' }, '<leader>lc', vim.lsp.buf.incoming_calls)
end

---@return nil
local function setup_diagnostics()
    vim.diagnostic.config {
        underline = false,
        severity_sort = true,

        -- disable built-in diagnostics display
        virtual_text = false,

        -- disable lsp_lines at start
        virtual_lines = false,
    }

    Map('n', '<leader>ld', vim.diagnostic.open_float)
    Map('n', '<leader>lD', vim.diagnostic.setloclist)
    Map('n', '[d', function()
        vim.diagnostic.jump { count = 1, float = true }
    end)
    Map('n', ']d', function()
        vim.diagnostic.jump { count = -1, float = true }
    end)
end

---@return nil
local function setup_lsp_lines()
    local lsp_lines = require 'lsp_lines'

    lsp_lines.setup {}

    Map('n', '<leader>tl', lsp_lines.toggle)
end

local lsps = {
    lua_ls = {
        on_attach = on_attach,

        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'nixCats' },
                },
            },
        },

        -- make lua_ls behave, when editing nvim config
        --
        -- modified from `:help lspconfig-all` (`lua_ls` section)
        on_init = function(client)
            if string.find(vim.fn.expand '%:p', 'nvim') == nil then
                return
            end

            client.config.settings.Lua =
                vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT',
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                        },
                    },

                    workspace = {
                        checkThirdParty = false,
                        library = { vim.env.VIMRUNTIME },
                    },
                })
        end,
    },

    jdtls = {
        on_attach = on_attach,
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
    },

    rust_analyzer = {
        on_attach = on_attach,
        settings = {
            -- all settings:
            -- https://rust-analyzer.github.io/book/configuration.html
            ['rust-analyzer'] = {
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
            },
        },
    },

    tinymist = { on_attach = on_attach },
    nixd = { on_attach = on_attach },
    bashls = { on_attach = on_attach },
    pyright = { on_attach = on_attach },
    ccls = { on_attach = on_attach },
}

---@return nil
function M.setup()
    require('utils.lsp').setup_lsps(lsps)

    setup_diagnostics()
    setup_lsp_lines()
end

return M
