local function setup_conform()
    require 'conform'.setup {
        formatters_by_ft = {
            nix = { 'alejandra' },
        },

        format_on_save = {
            timeout_ms = 2000,
            lsp_format = "fallback",
        },

        formatters = {
            alejandra = {
                command = AlejandraPath,
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
