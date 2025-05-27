local M = {}

--- returns:
--- {
---     path = <absolute path>|nil,
---     type = 'local'|'global'|'not_found',
--- }
local function resolve_lsp(lsp_local_path, lsp_global_path)
    if lsp_local_path ~= nil then
        lsp_local_path = vim.fn.exepath(lsp_local_path)

        if lsp_local_path == "" then
            lsp_local_path = nil
        end
    end

    if lsp_global_path == "" then
        lsp_global_path = nil
    end

    local type
    local path

    if lsp_local_path ~= nil then
        type = 'local'
        path = lsp_local_path
    elseif lsp_global_path ~= nil then
        type = 'global'
        path = lsp_global_path
    else
        type = 'not_found'
        path = nil
    end

    return {
        type = type,
        path = path,
    }
end

local function setup_lsp()
    for name, paths in pairs(nixCats.extra.lsps) do
        local resolved = resolve_lsp(paths.rel, paths.abs)
        local type = resolved.type
        local path = resolved.path

        if path == nil then
            goto next_lsp
        end

        local default_config = vim.lsp.config[name]
        local cmd
        if default_config ~= nil then
            cmd = default_config.cmd
            cmd[1] = path
        else
            cmd = path
        end

        vim.lsp.enable(name)
        vim.lsp.config(name, {
            cmd = cmd,
            on_attach = function()
                vim.notify(
                    'attached ' .. type .. ' "' .. name .. '" lsp server',
                    vim.log.levels.INFO
                )
            end
        })

        ::next_lsp::
    end
end

function M.setup()
    setup_lsp()
end

return M
