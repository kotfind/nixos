local M = {}

function M.setup()
    local blink = require 'blink-cmp'

    blink.setup {
        sources = { default = { 'lsp', 'buffer', 'path' }, },
        fuzzy = { implementation = 'prefer_rust_with_warning', },
        signature = { enabled = true, },

        completion = {
            accept = {
                -- seems to be broken, using separate plugin instead
                auto_brackets = { enabled = false, },
            },
        },

        keymap = {
            preset = 'none',

            ['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

            ['<up>'] = { 'select_prev', 'fallback' },
            ['<down>'] = { 'select_next', 'fallback' },

            ['<tab>'] = { 'select_prev', 'fallback' },
            ['<s-tab>'] = { 'select_next', 'fallback' },

            ['<cr>'] = { 'select_and_accept', 'fallback' },
        },
    }
end

return M
