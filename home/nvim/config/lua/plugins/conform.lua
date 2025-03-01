local function setup_conform()
    require 'conform'.setup {
        formatters_by_ft = {
            nix = { 'alejandra' },
            kotlin = { 'ktfmt' },
        },

        format_on_save = {
            timeout_ms = 10000,
            lsp_format = 'fallback',
            async = true,
        },

        formatters = {
            alejandra = { command = AlejandraPath, },
            ktfmt = {
                command = KtFmtPath,
                append_args = { '--kotlinlang-style' }
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
