local M = {}

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

        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'nixCats' },
                },
            },
        },
    }
}

---@return nil
function M.setup()
    local lsp_utils = require 'utils.lsp'
    lsp_utils.setup_lsps(lsps)
end

return M
