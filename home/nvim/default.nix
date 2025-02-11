{ pkgs, inputs, ... }:
let
    # format:
    # [ pkg lspconfig1 lspconfig2 ... ]
    #
    # Lspconfig server name list:
    #   https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    # or
    #   :help lspconfig-all
    lspServers = with pkgs; [
        [pyright "pyright"]
        [libclang "clangd"]
        [rust-analyzer "rust_analyzer"]
        [lua-language-server "lua_ls"]
        [tinymist "tinymist"]
        [bash-language-server "bashls"]
        [vscode-langservers-extracted "cssls" "eslint" "html" "jsonls"]
        [kotlin-language-server "kotlin_language_server"]
        [jdt-language-server "jdtls"]
        [nil "nil_ls"]
        [dot-language-server "dotls"]
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

        withNodeJs = true;
        withPython3 = false;
        withRuby = false;

        extraPackages =
            packages
            ++ (
                pkgs.lib.lists.forEach
                    lspServers
                    (spec: builtins.elemAt spec 0)
            );

        extraLuaConfig = let
                lspServerNames = pkgs.lib.lists.foldl
                    (acc: spec:
                        acc ++ (pkgs.lib.lists.drop 1 spec)
                    )
                    []
                    lspServers;

                lspServerNamesStr = pkgs.lib.lists.foldl
                    (acc: serverName:
                        acc + "\n'${serverName}',"
                    )
                    ""
                    lspServerNames;
            in
            /* lua */ ''
                -- this file was generatred by nix

                -- Export some variables
                LspServerNames = {
                    ${lspServerNamesStr}
                }

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
                    headless = {
                        task = false,
                    },
                }
            '';
    };

    ## Temporary disabled
    # home.activation.nvimLazySync = config.lib.dag.entryAfter ["writeBoundary"] ''
    #     PATH="$PATH:${pkgs.git}/bin:${pkgs.gcc}/bin" \
    #         run ${pkgs.neovim}/bin/nvim \
    #             --headless \
    #             -c ':Lazy! sync' \
    #             -c ':Lazy! load nvim-treesitter' \
    #             -c ':TSInstallSync all' \
    #             -c ':TSUpdateSync' \
    #             -c qa
    # '';

    home.sessionVariables = {
        MANPAGER = "nvim +Man!";
    };

    home.file =
        {
            ".config/nvim" = {
                recursive = true;
                source = pkgs.lib.sources.cleanSourceWith {
                    src = ./.;
                    # FIXME: Won't work for whatever reason
                    filter = name: type:
                        !(pkgs.lib.strings.hasSuffix name ".nix");
                };
            };
        }
        // (let
            spellPath = ".local/share/nvim/site/spell";
        in {
            "${spellPath}/ru.utf-8.spl".source = inputs.nvim-spl-ru;
            "${spellPath}/ru.utf-8.sug".source = inputs.nvim-sug-ru;
            "${spellPath}/en.utf-8.spl".source = inputs.nvim-spl-en;
            "${spellPath}/en.utf-8.sug".source = inputs.nvim-sug-en;
        });
}
