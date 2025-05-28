local M = {}

--- Tries to resolve an absolute path to given executable.
--- Prefers `rel` to `abs`.
---
---@param paths { rel: string?, abs: string? }
---@return { path: string, type: 'local' | 'global' }?
function M.resolve_cmd_path(paths)
    local lsp_local_path = paths.rel
    local lsp_global_path = paths.abs

    if lsp_local_path ~= nil then
        lsp_local_path = vim.fn.exepath(lsp_local_path)

        if lsp_local_path == '' then
            lsp_local_path = nil
        end
    end

    if lsp_global_path == '' then
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

return M
