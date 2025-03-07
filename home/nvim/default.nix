{
  pkgs,
  inputs,
  lib,
  system,
  ...
}:
# TODO?: don't install lsp servers for root?
let
  # Format:
  # <language_name> = {
  #   server = {
  #     name = <lspconfig-name>;
  #     path = lib.getExe pkgs.<package-name>;
  #   };
  #   formatter = {
  #     name = <conform-name>;
  #     path = lib.getExe pkgs.<package-name>;
  #   };
  # }
  # Lspconfig server name list:
  #   https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
  # or
  #   :help lspconfig-all
  langCfg = {
    python = {
      server = {
        name = "pyright";
        path = lib.getExe pkgs.pyright;
      };
      formatter = {
        name = "yapf";
        path = lib.getExe pkgs.yapf;
      };
    };

    c = {
      server = {
        name = "ccls";
        path = lib.getExe pkgs.ccls;
      };
    };

    rust = {
      server = {
        name = "rust_analyzer";
        path = lib.getExe pkgs.rust-analyzer;
      };
      formatter = {
        name = "rustfmt";
        path = lib.getExe pkgs.rustfmt;
      };
      linter = {
        name = "clippy";
        path = lib.getExe pkgs.clippy;
      };
    };

    lua = {
      server = {
        name = "lua_ls";
        path = lib.getExe pkgs.lua-language-server;
      };
      formatter = {
        name = "stylua";
        path = lib.getExe pkgs.stylua;
      };
    };

    typst = {
      server = {
        name = "tinymist";
        path = lib.getExe pkgs.tinymist;
      };
      formatter = {
        name = "typstyle";
        path = lib.getExe pkgs.typstyle;
      };
    };

    bash = {
      server = {
        name = "bashls";
        path = lib.getExe pkgs.bash-language-server;
      };
      formatter = {
        name = "shfmt";
        path = lib.getExe pkgs.shfmt;
      };
    };

    html = {
      server = {
        name = "html";
        path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
      };
      formatter = {
        name = "htmlbeautifier";
        path = lib.getExe pkgs.rubyPackages.htmlbeautifier;
      };
    };

    css = {
      server = {
        name = "cssls";
        path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
      };
      formatter = {
        name = "stylelint";
        path = lib.getExe pkgs.stylelint;
      };
    };

    json = {
      server = {
        name = "jsonls";
        path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
      };
      formatter = {
        name = "fixjson";
        path = lib.getExe pkgs.fixjson;
      };
    };

    javascript = {
      server = {
        name = "eslint";
        path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
      };
      # TODO: formatter
    };

    kotlin = {
      server = {
        name = "kotlin_language_server";
        path = lib.getExe pkgs.kotlin-language-server;
      };
      formatter = {
        name = "ktfmt";
        path = lib.getExe pkgs.ktfmt;
      };
    };

    java = {
      server = {
        name = "jdtls";
        path = lib.getExe pkgs.jdt-language-server;
      };
      formatter = {
        name = "google-java-format";
        path = lib.getExe pkgs.google-java-format;
      };
    };

    nix = {
      server = {
        name = "nixd";
        path = lib.getExe pkgs.nixd;
      };
      formatter = {
        name = "alejandra";
        path = lib.getExe pkgs.alejandra;
      };
    };

    dot = {
      server = {
        name = "dotls";
        path = lib.getExe pkgs.dot-language-server;
      };
    };
  };

  toLua = v:
    if v == null
    then "nil"
    else if builtins.isString v
    then "'" + lib.strings.escape ["'" "\\"] v + "'"
    else if builtins.isList v
    then "{" + lib.strings.concatMapStringsSep "," toLua v + "}"
    else if builtins.isAttrs v
    then "{" + lib.strings.concatMapAttrsStringSep "," (name: value: name + "=" + toLua value) v + "}"
    else throw "cannot convert to lua";

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

    extraPackages = packages;

    extraLuaConfig =
      /*
      lua
      */
      ''
        -- this file was generatred by nix

        -- Export some variables
        LangCfg = ${toLua langCfg}
        CodeiumPath = '${lib.getExe' codeium-lsp "codeium-lsp"}'

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
