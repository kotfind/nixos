local function setup_treesitter()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {},

        auto_install = false,

        highlight = {
            enable = true,
        },

        indent = {
            enable = false,
        },

        playground = {
            enable = true,
        },
    }
end

function InTreeSitterNode(node_type)
    local ts_utils = require 'nvim-treesitter.ts_utils'
    local node = ts_utils.get_node_at_cursor()
    while node ~= nil do
        if node:type() == node_type then
            return true
        end
        node = node:parent()
    end
    return false
end

function InTreeSitterTopLevelNode()
    local ts_utils = require 'nvim-treesitter.ts_utils'
    local node = ts_utils.get_node_at_cursor()
    print(node:parent())
    return node:parent() == nil
end

local function setup_textobjects()
    -- Text Objects List: https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
    local objects = {
        { 'f', 'function' },
        { 'l', 'loop' },
        { 'm', 'conditional' }, -- m for "match"
        { 'c', 'class' },
        { 'n', 'comment' }, -- n for "note"
        { 'a', 'parameter' }, -- a for "argument"
        { 't', 'statement' }, -- t for "sTatement" (s is for spelling)
    }

    local select = {}
    local goto_next_start = {}
    local goto_next_end = {}
    local goto_previous_start = {}
    local goto_previous_end = {}

    for _, object in ipairs(objects) do
        local letter = object[1]
        local name = object[2]

        assert(letter:match '^%l$' ~= nil, 'lowercase letter expected')

        local inner = '@' .. name .. '.inner'
        local outer = '@' .. name .. '.outer'

        select['i' .. letter] = inner
        select['a' .. letter] = outer
        goto_next_start[']' .. letter] = outer
        goto_next_end[']' .. letter:upper()] = outer
        goto_previous_start['[' .. letter] = outer
        goto_previous_end['[' .. letter:upper()] = outer
    end

    require('nvim-treesitter.configs').setup {
        textobjects = {
            select = {
                enable = true,
                lookahead = true,

                keymaps = select,
            },

            move = {
                enable = true,
                set_jump = true,

                goto_next_start = goto_next_start,
                goto_next_end = goto_next_end,
                goto_previous_start = goto_previous_start,
                goto_previous_end = goto_previous_end,
            },
        },
    }

    -- make moves repeatable with ; and .
    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    Map({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
    Map({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

    for _, key in ipairs { 'f', 't', 'F', 'T' } do
        Map(
            { 'n', 'x', 'o' },
            key,
            ts_repeat_move['builtin_' .. key .. '_expr'],
            { expr = true }
        )
    end
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        config = setup_treesitter,
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = setup_textobjects,
    },

    -- FIXME: disabled, as won't work with ts_repeat_move.builtin_?_key
    -- {
    --     'jinh0/eyeliner.nvim',
    --     opts = {
    --         highlight_on_key = true,
    --     },
    -- },
}
