{ pkgs, ... }:
let
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
    
    plugins = with pkgs.vimPlugins; [
        # NOTE:
        # - If plugin's name is `nvim-SMTH`, then
        #   lazy's plugin spec should contain `main = 'nvim-SMTH'`.
        # - If plugin's name is `SMTH.nvim`, then
        #   lazy's plugin spec should contain `main = 'SMTH'`.
        # Example:
        # ```
        # {
        #     'm4xshen/autoclose.nvim',
        #     main = 'autoclose',
        #     opts = {},
        # },
        # {
        #     'kylechui/nvim-surround',
        #     main = 'nvim-surround',
        #     opts = {},
        # },
        # ```

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
        plantuml-syntax
        nvim-lspconfig
        luasnip
        smear-cursor-nvim
        ssr-nvim
        nvim-ts-autotag
        autoclose-nvim
        fidget-nvim
        lsp_lines-nvim
        persistence-nvim
        nvim-ts-context-commentstring
        dressing-nvim
        comment-nvim
        typst-preview-nvim
        popup-nvim
        plenary-nvim
        nvim-web-devicons
        telescope-nvim # NOTE: extentions don't seem to work
        telescope-symbols-nvim
        telescope-undo-nvim
        cmp-nvim-lsp
    ];

    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        bash
        c
        cpp
        diff
        html
        css
        javascript
        json
        lua
        markdown
        markdown_inline
        python
        query
        toml
        vim
        vimdoc
        xml
        yaml
        rust
        nasm
        typst
        toml
        gitcommit
        comment
        java
    ];

    lspServers = with pkgs; [
        pyright
        libclang
        rust-analyzer
        lua-language-server
        tinymist
        bash-language-server
        vscode-langservers-extracted
        kotlin-language-server
        java-language-server
        nil
    ];

    packages = with pkgs; [
        xclip
    ];
in {
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;
        viAlias = true;

        plugins = plugins ++ treesitterParsers;

        extraPackages = packages ++ lspServers;

        extraLuaConfig = let
                dirs = pkgs.neovim.passthru.packpathDirs;
                installPath = "${pkgs.vimUtils.packDir dirs}/pack/myNeovimPackages/start";
            in ''
                -- this file was generatred by nix
                -- require actual init file
                require 'main'

                -- Init lazy
                require 'lazy'.setup('plugins', {
                    spec = {
                        { import = "plugins", },
                    },
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
                    checker = {
                        enabled = false,
                    },
                    readme = {
                        enabled = false,
                    },
                    profiling = {
                        loader = true,
                        require = true,
                    },
                    pkg = {
                        sources = { 'lazy' },
                    },
                })
            '';
    };

    home.file.".config/nvim" = {
        source = ./.config/nvim;
        recursive = true;
    };

    home.sessionVariables = {
        MANPAGER = "nvim +Man!";
    };
}
