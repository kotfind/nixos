local o = vim.opt

-- Mouse
o.mouse = 'a'

-- Tab
o.tabstop = 4
o.expandtab = true
o.softtabstop = 4
o.shiftwidth = 4

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true

o.termguicolors = true
o.showmode = false

o.scrolloff = 5

-- Split
o.splitbelow = true
o.splitright = true

-- Search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true

-- Undo file
o.undofile = true

-- Wrap
o.wrap = false
o.linebreak = true
o.breakindent = true

-- Preserve cursor position
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    command = [[ silent! normal! g`"zv' ]]
})

-- Spell
o.spelllang = { 'en', 'ru' }

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        '*.typ',
        '*.txt',
        '*.md',
        '*.rs',
    },
    callback = function()
        o.spell = true
    end
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    callback = function()
        o.spell = false
    end
})
