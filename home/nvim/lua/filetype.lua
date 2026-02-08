local M = {}

function M.setup()
    vim.filetype.add {
        filename = {
            ['Caddyfile'] = 'caddy',
        },
    }
end

return M
