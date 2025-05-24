--
-- This file sets up some text manipulation logics, like 
-- commenting and surrounding with braces, hence the name.
--

local M = {}

local function setup_comment()
    require 'ts_context_commentstring'.setup {
        enable_autocmd = false,
    }

    require 'Comment'.setup {
        pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
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

local function setup_braces()
    require 'nvim-surround'.setup {}
    require 'autoclose'.setup {}
    require 'nvim-ts-autotag'.setup {}
end

function M.setup()
    setup_comment()
    setup_braces()
end

return M
