{ pkgs, inputs, lib, system, ... }:
# TODO?: don't install lsp servers for root?
let
    # format:
    # [ pkg1 pkg2 ... lspconfig1 lspconfig2 ... ]
    #
    # Lspconfig server name list:
    #   https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    # or
    #   :help lspconfig-all
    lspServers = lib.lists.flatten (with pkgs; [
        [
            "pyright"
            pyright
            yapf
        ]

        [
            "ccls"
            ccls
        ]

        [
            "rust_analyzer"
            rust-analyzer
            rustfmt
            clippy
        ]

        [
            "lua_ls"
            lua-language-server
            luaformatter
        ]

        [
            "tinymist"
            tinymist
            prettypst
        ]

        [
            "bashls"
            bash-language-server
            shfmt
        ]

        [
            "cssls"
            "eslint"
            "html"
            "jsonls"
            vscode-langservers-extracted
            perl540Packages.HTMLFormatter
        ]

        [
            "kotlin_language_server"
            kotlin-language-server
            ktlint
        ]

        [
            "jdtls"
            jdt-language-server
            google-java-format
        ]

        [
            "nixd"
            nixd
            alejandra
        ]

        [
            "dotls"
            dot-language-server
        ]
    ]);

    codeium-lsp = inputs.codeium.packages.${system}.codeium-lsp;


    packages = [
        pkgs.xclip
        codeium-lsp
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
                lib.lists.filter
                    (spec: lib.attrsets.isDerivation spec)
                    lspServers
            );

        extraLuaConfig = let
                lspServerNames = lib.lists.filter
                    (spec: lib.strings.isString spec)
                    lspServers;

                lspServerNamesStr = lib.lists.foldl
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

                CodeiumPath = '${lib.getExe codeium-lsp}'

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

    home.sessionVariables = {
        MANPAGER = "nvim +Man! -c ':set signcolumn=no'";
    };

    home.file =
        {
            ".config/nvim" = {
                source = ./config;
                recursive = true;
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
