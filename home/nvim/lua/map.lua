---@param modes string|string[]
---@param key string
---@param func string|function
---@param opts vim.keymap.set.Opts?
function Map(modes, key, func, opts)
    if opts == nil then
        opts = {
            noremap = true,
            silent = true,
        }
    end

    vim.keymap.set(modes, key, func, opts)
end

function Feed(keys)
    vim.fn.feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, true, true),
        true
    )
end

local M = {}

function M.setup()
    -- Langmap
    vim.opt.langmap =
        'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

    -- Set leader
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    Map('n', '<space>', '')

    -- Move between windows
    Map({ 'n', 't' }, '<C-h>', '<C-w>h')
    Map({ 'n', 't' }, '<C-j>', '<C-w>j')
    Map({ 'n', 't' }, '<C-k>', '<C-w>k')
    Map({ 'n', 't' }, '<C-l>', '<C-w>l')

    -- Reselect on shift
    Map('v', '<', '<gv')
    Map('v', '>', '>gv')

    -- Move on wrapped lines
    Map({ 'n', 'x' }, 'j', 'gj')
    Map({ 'n', 'x' }, 'k', 'gk')
    Map({ 'n', 'x' }, '^', 'g^')
    Map({ 'n', 'x' }, '$', 'g$')

    Map({ 'n', 'x' }, 'gj', 'j')
    Map({ 'n', 'x' }, 'gk', 'k')
    Map({ 'n', 'x' }, 'g^', '^')
    Map({ 'n', 'x' }, 'g$', '$')

    -- No highlight
    Map('n', '<leader><esc>', ':nohlsearch<cr>')

    -- Insert -> Normal
    Map('i', 'jk', '<esc>')
    Map('i', 'Jk', '<esc>')
    Map('i', 'jK', '<esc>')
    Map('i', 'JK', '<esc>')

    -- Terminal -> Normal
    Map('t', '<esc><esc>', '<C-\\><C-N>')

    -- Global buffer yank/ paste/ delete
    Map({ 'n', 'x' }, '<leader>p', '"+p')
    Map({ 'n', 'x' }, '<leader>P', '"+P')
    Map({ 'n', 'x' }, '<leader>d', '"+d')
    Map({ 'n', 'x' }, '<leader>y', '"+y')
    Map('n', '<leader>yy', '"+yy')

    -- Select pasted
    Map('n', 'gp', "V'[']")

    -- Toggle Spellcheck
    Map('n', '<leader>ts', function()
        vim.opt.spell = not vim.opt.spell:get()
    end)

    -- Quicklist
    Map('n', '<leader>qn', ':cnext<cr>')
    Map('n', '<leader>qp', ':cprev<cr>')
    Map('n', '<leader>qf', ':cfirst<cr>')
    Map('n', '<leader>ql', ':clast<cr>')
end

return M
