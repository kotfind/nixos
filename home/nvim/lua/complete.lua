local M = {}

local function setup_luasnip()
    local luasnip = require 'luasnip'

    luasnip.config.setup {
        enable_autosnippets = true,
        store_selection_keys = '<C-j>',
    }
end

local function setup_blink()
    local blink = require 'blink-cmp'

    blink.setup {
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        signature = { enabled = true },
        snippets = { preset = 'luasnip' },

        keymap = {
            preset = 'none',

            ['<c-space>'] = {
                'show',
                'show_documentation',
                'hide_documentation',
            },

            ['<up>'] = { 'select_prev', 'fallback' },
            ['<down>'] = { 'select_next', 'fallback' },

            ['<tab>'] = { 'select_next', 'fallback' },
            ['<s-tab>'] = { 'select_prev', 'fallback' },

            ['<cr>'] = { 'select_and_accept', 'fallback' },

            ['<c-h>'] = { 'snippet_forward', 'fallback' },
            ['<c-l>'] = { 'snippet_backward', 'fallback' },
        },
    }
end

function M.setup()
    setup_luasnip()
    setup_blink()
end

return M
