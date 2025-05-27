local M = {}

---@param name string name of lsp server, as specified in lspconfig
---@return { path: string, type: 'local' | 'global' }?
local function resolve_lsp_path(name)
    local cats_paths = nixCats.extra.lsps[name]
    if cats_paths == nil then
        error('lsp "' .. name .. '" is not defined in nixCats')
    end

    local lsp_local_path = cats_paths.rel
    local lsp_global_path = cats_paths.abs

    if lsp_local_path ~= nil then
        lsp_local_path = vim.fn.exepath(lsp_local_path)

        if lsp_local_path == "" then
            lsp_local_path = nil
        end
    end

    if lsp_global_path == "" then
        lsp_global_path = nil
    end

    if lsp_local_path ~= nil then
        return {
            type = 'local',
            path = lsp_local_path,
        }
    elseif lsp_global_path ~= nil then
        return {
            type = 'global',
            path = lsp_global_path,
        }
    else
        return nil
    end
end

---@param name string name of lsp server, as specified in lspconfig
---@param path string absolute path to lsp server executable
---@param config_cmd string[]? command and arguments to execute lsp server,
---     the first argument will be overridden
---@return string[]
local function resolve_cmd(name, path, config_cmd)
    local cmd
    local default_config = vim.lsp.config[name]

    if config_cmd ~= nil then
        cmd = config_cmd
        cmd[1] = path
    elseif default_config ~= nil then
        cmd = default_config.cmd
        assert(type(cmd) == 'table')
        cmd[1] = path
    else
        cmd = { path }
    end

    return cmd
end

---@param name string name of lsp server, as specified in lspconfig
---@param path_type ('local' | 'global') value from resolve_lsp_path
---@param config_on_attach fun(self: vim.lsp.Client, bufnr: integer)? your custom on_attach function
---@return nil
local function resolve_on_attach(name, path_type, config_on_attach)
    return function(client, bufnr)
        vim.notify(
            'attached ' .. path_type .. ' "' .. name .. '" lsp server',
            vim.log.levels.INFO
        )

        if config_on_attach ~= nil then
            config_on_attach(client, bufnr)
        end
    end
end

---@param name string name of lsp server, as specified in lspconfig
---@param config vim.lsp.Config
---@return nil
local function setup_lsp_server(name, config)
    local lsp_path = resolve_lsp_path(name)
    if lsp_path == nil then
        return
    end

    local cmd = resolve_cmd(name, lsp_path.path, config.cmd --[[@as string[]?]])

    ---@diagnostic disable-next-line: param-type-mismatch
    local on_attach = resolve_on_attach(name, lsp_path.type, config.on_attach)

    config.cmd = cmd
    config.on_attach = on_attach

    vim.lsp.enable(name)
    vim.lsp.config(name, config)
end

---@param lsps table<string, table<any, any>> name of lsp server -> it's settings
---@return nil
local function setup_lsp(lsps)
    for name, config in pairs(lsps) do
        setup_lsp_server(name, config)
    end
end

---@return nil
function M.setup()
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

    setup_lsp(lsps)
end

return M
