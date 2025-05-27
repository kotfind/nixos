local M = {}

--- returns a table of settings, that should be
--- passsed to treesitter config:
--- ```
--- require 'nvim-treesitter.configs' = {
---     textobjects = <HERE>
--- }
--- ```
local function setup_textobjects()
    -- textobjects list: https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
    local objects = {
        { 'f', 'function' },
        { 'l', 'loop' },
        { 'i', 'conditional' }, -- i for "if"
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

    local textobjects_config = {
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

    return textobjects_config
end

local function setup_treesitter(textobjects_config)
    local config = require 'nvim-treesitter.configs'

    config.setup {
        auto_install = false,
        indent = { enable = false, },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
        textobjects = textobjects_config
    }
end

local function setup_treewalker()
    require 'treewalker'.setup {}

    Map({ 'n', 'v' }, '<m-k>', '<cmd>Treewalker Up<cr>')
    Map({ 'n', 'v' }, '<m-j>', '<cmd>Treewalker Down<cr>')
    Map({ 'n', 'v' }, '<m-h>', '<cmd>Treewalker Left<cr>')
    Map({ 'n', 'v' }, '<m-l>', '<cmd>Treewalker Right<cr>')

    Map('n', '<m-c-k>', '<cmd>Treewalker SwapUp<cr>')
    Map('n', '<m-c-j>', '<cmd>Treewalker SwapDown<cr>')
    Map('n', '<m-c-h>', '<cmd>Treewalker SwapLeft<cr>')
    Map('n', '<m-c-l>', '<cmd>Treewalker SwapRight<cr>')
end

function M.setup()
    local textobjects_config = setup_textobjects()
    setup_treesitter(textobjects_config)
    setup_treewalker()
end

return M
