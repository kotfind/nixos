{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;
        viAlias = true;
        withNodeJs = true; # delete me

        plugins = let
            # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/doc/languages-frameworks/vim.section.md#what-if-your-favourite-vim-plugin-isnt-already-packaged-what-if-your-favourite-vim-plugin-isnt-already-packaged
            smear-cursor-nvim = pkgs.vimUtils.buildVimPlugin {
                name = "smear-cursor.nvim";
		# TODO: try to use flakes here
                src = pkgs.fetchFromGitHub {
                    owner = "sphamba";
                    repo = "smear-cursor";
                    rev = "005b50b891d662bdd3160dc2a143939066b5cc17";
                    hash = "sha256-bL6lv+h6TgTo4YXu/gBnfw31GEKQnMUlxB0ZTVpWF1A=";
                };
            };
        in
        with pkgs.vimPlugins; [
            lazy-nvim
            nvim-surround
            vim-signify
            nvim-treesitter-textobjects
            eyeliner-nvim
            nvim-treesitter
            lualine-nvim
            pest-vim
            nvim-cmp
            neoscroll-nvim
            cyberdream-nvim
            # mason-nvim
            plantuml-syntax
            nvim-lspconfig
            luasnip
            smear-cursor-nvim
            # mason-lspconfig-nvim
            ssr-nvim
            nvim-ts-autotag
            autoclose-nvim
            telescope-nvim
            fidget-nvim
            lsp_lines-nvim
            persistence-nvim
            nvim-ts-context-commentstring
            dressing-nvim
            comment-nvim
            typst-preview-nvim
        ];

        extraLuaConfig = let
            dirs = pkgs.neovim.passthru.packpathDirs;
            installPath = "${pkgs.vimUtils.packDir dirs}/pack/myNeovimPackages/start";
        in ''
            -- this file was generatred by nix
            -- require actual init file
            require 'main'

            -- Init lazy
            require 'lazy'.setup('plugins', {
                performance = {
                    reset_packpath = false,
                    rtp = { reset = false, },
                },
                dev = {
                    path = "${installPath}",
                    patterns = { "" },
                },
                install = {
                    missing = false,
		    colorscheme = {},
                },
            })

            -- vim.opt.rtp:prepend("${installPath}")
        '';
    };

    home.file.".config/nvim" = {
        source = ./.config/nvim;
        recursive = true;
    };

    home.packages = with pkgs; [
        unzip # TODO: delete me
        xclip
    ];
}
