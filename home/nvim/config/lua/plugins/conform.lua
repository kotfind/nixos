local function setup_conform()
    require 'conform'.setup {
        formatters_by_ft = {
            nix = { 'alejandra' },
            typst = { 'typstyle' },
            lua = { 'stylua' },
            rust = { 'rustfmt' },
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
            }
        },
        format_after_save = {
            timeout_ms = 10000,
        },
    }
end

return {
    {
        'stevearc/conform.nvim',
        config = setup_conform,
    },
}
