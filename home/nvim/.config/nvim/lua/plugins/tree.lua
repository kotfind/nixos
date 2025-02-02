local function setup_tree()
    Map('n', '<leader>tt', ':NvimTreeToggle<CR>')
    require 'nvim-tree'.setup {}
end

return {
    {
        'nvim-tree/nvim-tree.lua',
        config = setup_tree,
    },
}
