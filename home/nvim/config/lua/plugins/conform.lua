local function setup_conform()
    local util = require 'conform.util'

    require 'conform'.setup {
        formatters_by_ft = {
            nix = { 'alejandra' },
            kotlin = { 'ktfmt' },
            cpp = { 'astyle' },
            c = { 'astyle' },
        },

        format_after_save = {
            timeout_ms = 10000,
            lsp_format = 'fallback',
        },

        formatters = {
            alejandra = { command = AlejandraPath, },
            ktfmt = {
                command = KtFmtPath,
                append_args = { '--kotlinlang-style' }
            },

            -- custom formatter
            astyle = {
                command = AstylePath,
                args = {},
                stdin = true,
                cwd = util.root_file {
                    '.editorconfig',
                    'flake.nix',
                    '.git',
                },
            },
        },
    }
end

return {
    {
        'stevearc/conform.nvim',
        config = setup_conform
    }
}
