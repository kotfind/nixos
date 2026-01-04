local M = {}

function M.setup()
    require('utils.format').setup_conform({
        formatters_by_ft = {
            ['*'] = { 'injected' },
            lua = { 'stylua' },
            nix = { 'alejandra' },
            typst = { 'typstyle' },
            rust = { 'leptosfmt', 'rustfmt' },
            python = { 'black' },
            jinja = { 'djlint' },
            toml = { 'tombi' },
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
