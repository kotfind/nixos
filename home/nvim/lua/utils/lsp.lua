local M = {}

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
function M.setup_lsp_server(name, config)
    local cats_paths = nixCats.extra.lsps[name]
    if cats_paths == nil then
        error('lsp server "' .. name .. '" is not specified in nixCats')
    end

    local lsp_path = require('utils.path').resolve_cmd_path(cats_paths)
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
function M.setup_lsps(lsps)
    for name, config in pairs(lsps) do
        M.setup_lsp_server(name, config)
    end
end

return M
