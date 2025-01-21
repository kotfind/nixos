{ pkgs, ... }:
let
    plugins = with pkgs.vimPlugins; [
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

        extraLuaConfig = ''
            -- this file was generatred by nix

            -- require actual init file
            require 'main'

            -- Install lazy
            local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
            if not (vim.uv or vim.loop).fs_stat(lazypath) then
              local lazyrepo = "https://github.com/folke/lazy.nvim.git"
              local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
              if vim.v.shell_error ~= 0 then
                vim.api.nvim_echo({
                  { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                  { out, "WarningMsg" },
                  { "\nPress any key to exit..." },
                }, true, {})
                vim.fn.getchar()
                os.exit(1)
              end
            end
            vim.opt.rtp:prepend(lazypath)

            -- Init lazy
            require 'lazy'.setup({
                spec = {
                    { import = "plugins", },
                },
                performance = {
                    reset_packpath = false,
                    rtp = { reset = false, },
                },
                install = {
                    colorscheme = {},
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
