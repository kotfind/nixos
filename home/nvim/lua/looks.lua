local M = {}

local function setup_theme()
    require 'cyberdream'.setup {
        italic_comments = true,
        borderless_pickers = true,
        variant = 'auto',
        overrides = function(colors)
            return {
                CursorLine = { fg = 'NONE', bg = colors.bg_alt },

                Comment = { fg = colors.magenta, bg = 'NONE', italic = true },
                ['@note.comment'] = { fg = colors.cyan, bold = true },
            }
        end,
    }

    vim.cmd [[ colorscheme cyberdream ]]
end

local function setup_lualine()
  require 'lualine'.setup {
        options = {
            theme = require 'lualine.themes.cyberdream',
            component_separators = {
                left = '',
                right = '',
            },
        },

        sections = {
            lualine_a = {
                {
                    'filename',
                    newfile_status = true,
                    path = 1,
                },
            },
            lualine_b = { 'branch' },
            lualine_c = {},
            lualine_x = {
                {
                    'diagnostics',
                    update_in_insert = true,
                },
            },
            lualine_y = { 'filetype' },
            lualine_z = { 'location', 'progress' },
        },

        inactive_sections = {
            lualine_a = {
                {
                    'filename',
                    newfile_status = true,
                    path = 1,
                },
            },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    }
end

local function setup_notify()
    local notify = require 'notify'
    vim.notify = notify

    notify.setup {
        render = 'wrapped-compact',
        stages = 'fade',
    }
end

function M.setup()
    setup_theme()
    setup_lualine()
    setup_notify()

    require 'smear_cursor'.setup {}
    require 'neoscroll'.setup {}
    require 'nvim-web-devicons'.setup {}
end

return M
