local M = {}

function M.setup()
    require('utils.format').setup_conform({
        formatters_by_ft = {
            lua = { 'stylua' },
            ['*'] = { 'injected' },
        },
        formatters = {
            stylua = {
                append_args = {
                    '--column-width',
                    '80',
                    '--indent-type',
                    'Spaces',
                    '--quote-style',
                    'AutoPreferSingle',
                    '--call-parentheses',
                    'None',
                    '--indent-width',
                    '4',
                },
            },

            typstyle = {
                append_args = { '--tab-width', '4' },
            },
        },
        format_after_save = {
            timeout_ms = 10000,
        },
    }, { 'injected' })
end

return M
