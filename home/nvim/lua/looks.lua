local M = {}

local function setup_theme()
    require('cyberdream').setup {
        italic_comments = true,
        borderless_pickers = true,
        variant = 'auto',
        overrides = function(colors)
            return {
                CursorLine = { fg = 'NONE', bg = colors.bg_alt },

                Comment = { fg = colors.magenta, bg = 'NONE', italic = true },
                ['@note.comment'] = { fg = colors.cyan, bold = true },

                -- for listchars
                Whitespace = { fg = colors.white, bg = colors.red },
            }
        end,
    }

    vim.cmd [[ colorscheme cyberdream ]]
end

--- synchronizes vim.opt.background with system,
--- based of ~/.config/alacritty/active-theme.toml file
local function setup_sync_background()
    local theme_symlink = vim.fn.expand '~/.config/alacritty/active-theme.toml'

    local timer = vim.uv.new_timer()
    local timer_delay = 100 -- ms

    timer:start(
        0,
        timer_delay,
        vim.schedule_wrap(function()
            local theme_file = vim.uv.fs_readlink(theme_symlink)
            if theme_file == nil then
                vim.notify(
                    'failed to read theme symlink' .. theme_symlink,
                    vim.log.levels.ERROR
                )
                timer:stop()
                return
            end

            if string.find(theme_file, 'light', 1, true) then
                vim.opt.background = 'light'
            elseif string.find(theme_file, 'dark', 1, true) then
                vim.opt.background = 'dark'
            else
                vim.notify(
                    'failed to determine theme type of file: ' .. theme_file,
                    vim.log.levels.ERROR
                )
                timer:stop()
                return
            end
        end)
    )
end

local function setup_lualine()
    require('lualine').setup {
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
    -- local notify = require 'notify'
    --
    -- notify.setup {
    --     render = 'wrapped-compact',
    --     stages = 'fade',
    -- }
end

local function setup_noice()
    local noice = require 'noice'

    noice.setup {
        cmdline = { view = 'cmdline' },
        messages = {
            view = 'mini',
            view_error = 'mini',
            view_warn = 'mini',
            view_search = false,
        },
        lsp = {
            hover = { enabled = false },
            signature = { enabled = false },
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
            },
        },
    }
end

function M.setup()
    setup_theme()
    setup_lualine()
    setup_notify()
    setup_noice()
    setup_sync_background()

    require('smear_cursor').setup {}
    require('neoscroll').setup {}
    require('nvim-web-devicons').setup {}
end

return M
