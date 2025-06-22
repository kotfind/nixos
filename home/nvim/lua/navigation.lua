local M = {}

---@return nil
local function setup_telescope()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local actions = require 'telescope.actions'

    telescope.setup {
        defaults = {
            sorting_strategy = 'ascending',
            layout_strategy = 'horizontal',
            layout_config = {
                width = 0.8,
                prompt_position = 'top',
            },
            mappings = {
                i = {
                    -- move
                    ['<tab>'] = actions.move_selection_next,
                    ['<s-tab>'] = actions.move_selection_previous,

                    -- select
                    ['<c-s>'] = actions.toggle_selection,
                    ['<c-s-s>'] = actions.toggle_all,
                    ['<c-j>'] = function(prompt_bufnr)
                        actions.toggle_selection(prompt_bufnr)
                        actions.move_selection_next(prompt_bufnr)
                    end,
                    ['<c-k>'] = function(prompt_bufnr)
                        actions.toggle_selection(prompt_bufnr)
                        actions.move_selection_previous(prompt_bufnr)
                    end,

                    -- exit
                    ['<esc>'] = actions.close,
                },
            },
        },
    }
    telescope.load_extension 'undo'
    telescope.load_extension 'noice'

    -- files
    Map('n', '<leader>ff', builtin.find_files)
    Map('n', '<leader>fb', builtin.buffers)

    -- find
    Map('n', '<leader>fg', builtin.live_grep)
    Map('n', '<leader>f/', builtin.current_buffer_fuzzy_find)

    -- lsp
    Map('n', '<leader>fs', builtin.lsp_document_symbols)
    Map('n', '<leader>fS', builtin.lsp_workspace_symbols)

    Map('n', '<leader>fd', function()
        builtin.diagnostics {
            severity_limit = 'WARN',
            bufnr = 0,
        }
    end)
    Map('n', '<leader>fD', function()
        builtin.diagnostics {
            severity_limit = 'WARN',
        }
    end)

    Map('n', '<leader>fr', builtin.lsp_references)

    -- extensions
    Map('n', '<leader>fu', telescope.extensions.undo.undo)

    -- other
    Map('n', '<leader>fl', builtin.spell_suggest)
    Map('n', 'z=', function()
        vim.notify(
            '"z=" is disabled, use "<leader>fl" instead',
            vim.log.levels.ERROR
        )
    end)

    Map('n', '<leader>fh', builtin.help_tags)
    Map('n', '<leader>F', builtin.resume)
end

---@return nil
local function setup_tree()
    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local api = require 'nvim-tree.api'

    Map('n', '<leader>tt', api.tree.toggle)
    require('nvim-tree').setup {
        hijack_cursor = true,
        disable_netrw = true,
        view = {
            width = {
                min = 20,
                max = 30,
                padding = 1,
            },
        },
        renderer = {
            group_empty = true,
            add_trailing = true,
        },
        tab = {
            sync = {
                open = true,
                close = true,
            },
        },
    }
end

---@return nil
function M.setup()
    setup_telescope()
    setup_tree()
end

return M
