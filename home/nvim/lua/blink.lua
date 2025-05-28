local M = {}

function M.setup()
    local blink = require 'blink-cmp'

    blink.setup {
        sources = { default = { 'lsp', 'buffer', 'path' }, },
        fuzzy = { implementation = 'prefer_rust_with_warning', },
        signature = { enabled = true, },

        keymap = {
            preset = 'none',

            ['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

            ['<up>'] = { 'select_prev', 'fallback' },
            ['<down>'] = { 'select_next', 'fallback' },

            ['<tab>'] = { 'select_next', 'fallback' },
            ['<s-tab>'] = { 'select_prev', 'fallback' },

            ['<cr>'] = { 'select_and_accept', 'fallback' },
        },
    }
end

return M
