local M = {}

local function setup_treesitter()
    local config = require 'nvim-treesitter.configs'

    config.setup {
        auto_install = false,
        indent = { enable = false, },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
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
    setup_treesitter()
    setup_treewalker()
end

return M
