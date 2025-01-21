{ pkgs, inputs, ... }:
let
    plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
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

        withNodeJs = false;
        withPython3 = false;
        withRuby = false;

        plugins = plugins;
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
            require 'lazy'.setup {
                spec = { { import = "plugins", }, },
                install = { colorscheme = {}, },
                readme = { enabled = false, },
                profiling = {
                    loader = true,
                    require = true,
                },
                pkg = { sources = { 'lazy' }, },
                rocks = { enabled = false, },
            }
        '';
    };

    home.sessionVariables = {
        MANPAGER = "nvim +Man!";
    };

    home.file = let
            spellPath = ".local/share/nvim/site/spell";
        in {
            ".config/nvim" = {
                source = ./.config/nvim;
                recursive = true;
            };

            "${spellPath}/ru.utf-8.spl".source = inputs.nvim-spl-ru;
            "${spellPath}/ru.utf-8.sug".source = inputs.nvim-sug-ru;
            "${spellPath}/en.utf-8.spl".source = inputs.nvim-spl-en;
            "${spellPath}/en.utf-8.sug".source = inputs.nvim-sug-en;
        };
}
