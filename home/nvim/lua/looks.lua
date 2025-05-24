require 'cyberdream'.setup {
    italic_comments = true,
    borderless_pickers = true,
    variant = 'auto',
    overrides = function(colors)
        return {
    	CursorLine = { fg = 'NONE', bg = colors.bgAlt },

    	Comment = { fg = colors.magenta, bg = 'NONE', italic = true },
    	['@note.comment'] = { fg = colors.cyan, bold = true },

    	EyelinerPrimary = { fg = 'white', bg = colors.magenta },
    	EyelinerSecondary = { fg = 'white', bg = colors.cyan },
        }
    end,
}

vim.cmd [[ colorscheme cyberdream ]]
