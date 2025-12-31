--
-- This file sets up some text manipulation logics, like
-- commenting and surrounding with braces, hence the name.
--

local M = {}

local function setup_comment()
    require('ts_context_commentstring').setup {
        enable_autocmd = false,
    }

    require('Comment').setup {
        pre_hook = require(
            'ts_context_commentstring.integrations.comment_nvim'
        ).create_pre_hook(),
        toggler = {
            line = '<leader>cc',
            block = '<leader>bc',
        },
        opleader = {
            line = '<leader>c',
            block = '<leader>b',
        },
        extra = {
            above = '<leader>cO',
            below = '<leader>co',
            eol = '<leader>cA',
        },
    }
end

local function setup_autoclose()
    require('autoclose').setup {
        keys = {
            -- disabling single quote as it's lifetime specifier in rust
            ["'"] = { enabled_filetypes = {} },
        },
    }
end

function M.setup()
    setup_comment()
    setup_autoclose()

    require('nvim-surround').setup {}
    require('nvim-ts-autotag').setup {}
end

return M
