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

local lsps = {
    lua_ls = {
        -- make lua_ls behave, when editing nvim config
        --
        -- modified from `:help lspconfig-all` (`lua_ls` section)
        on_init = function(client)
            if string.find(vim.fn.expand('%:p'), 'nvim') == nil then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
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

        on_attach = on_attach,

        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'nixCats' },
                },
            },
        },
    },
}

---@return nil
function M.setup()
    local lsp_utils = require 'utils.lsp'
    lsp_utils.setup_lsps(lsps)
end

return M
