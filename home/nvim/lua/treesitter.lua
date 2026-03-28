local M = {}

--- A pair of key to bind and treesitter object from
--- https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
---@alias TextObjectDef {[1]:string, [2]:string}

--- Enables mappings
---@param objects TextObjectDef[]
---@return nil
local function setup_textobject_maps(objects)
    local ts_select = require 'nvim-treesitter-textobjects.select'
    local ts_move = require 'nvim-treesitter-textobjects.move'

    for _, object in ipairs(objects) do
        local letter = object[1]
        local name = object[2]

        assert(letter:match '^%l$' ~= nil, 'lowercase letter expected')

        local inner = '@' .. name .. '.inner'
        local outer = '@' .. name .. '.outer'

        Map({ 'x', 'o' }, 'i' .. letter, function()
            ts_select.select_textobject(inner, 'textobjects')
        end)

        Map({ 'x', 'o' }, 'a' .. letter, function()
            ts_select.select_textobject(outer, 'textobjects')
        end)

        Map({ 'n', 'x', 'o' }, ']' .. letter, function()
            ts_move.goto_next_start(outer, 'textobjects')
        end)

        Map({ 'n', 'x', 'o' }, ']' .. letter:upper(), function()
            ts_move.goto_next_end(outer, 'textobjects')
        end)

        Map({ 'n', 'x', 'o' }, '[' .. letter, function()
            ts_move.goto_previous_start(outer, 'textobjects')
        end)

        Map({ 'n', 'x', 'o' }, '[' .. letter:upper(), function()
            ts_move.goto_previous_end(outer, 'textobjects')
        end)
    end
end

-- Makes textobject moves repeatable with ; and .
local function setup_textobject_repeat()
    local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

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

---@return nil
local function setup_treesitter()
    require('nvim-treesitter').setup {
        auto_install = false,
        indent = { enable = false },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
    }
end

---@return nil
local function setup_treewalker()
    require('treewalker').setup {}

    Map({ 'n', 'v' }, '<m-k>', '<cmd>Treewalker Up<cr>')
    Map({ 'n', 'v' }, '<m-j>', '<cmd>Treewalker Down<cr>')
    Map({ 'n', 'v' }, '<m-h>', '<cmd>Treewalker Left<cr>')
    Map({ 'n', 'v' }, '<m-l>', '<cmd>Treewalker Right<cr>')

    Map('n', '<m-c-k>', '<cmd>Treewalker SwapUp<cr>')
    Map('n', '<m-c-j>', '<cmd>Treewalker SwapDown<cr>')
    Map('n', '<m-c-h>', '<cmd>Treewalker SwapLeft<cr>')
    Map('n', '<m-c-l>', '<cmd>Treewalker SwapRight<cr>')
end

---@return nil
local function setup_textobjects()
    -- textobjects list: https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects
    setup_textobject_maps {
        { 'f', 'function' },
        { 'l', 'loop' },
        { 'i', 'conditional' }, -- i for "if"
        { 'c', 'class' },
        { 'n', 'comment' }, -- n for "note"
        { 'a', 'parameter' }, -- a for "argument"
        { 't', 'statement' }, -- t for "sTatement" (s is for spelling)
    }
    setup_textobject_repeat()
end

---@return nil
function M.setup()
    setup_treesitter()
    setup_treewalker()
    setup_textobjects()
end

return M
