local function setup_tree()
    Map('n', '<leader>tt', ':NvimTreeToggle<CR>')
    require 'nvim-tree'.setup {
        view = {
            width = 60,
        },
    }
end

return {
    {
        'nvim-tree/nvim-tree.lua',
        config = setup_tree,
    },
}
