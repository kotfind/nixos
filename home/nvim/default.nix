{
  pkgs,
  inputs,
  lib,
  system,
  ...
}:
# TODO?: don't install lsp servers for root?
let
  inherit (lib) getExe getExe';
  inherit (lib.strings) escape concatMapStringsSep concatMapAttrsStringSep;
  inherit (pkgs) writeShellScriptBin;

  customJavaFormatter = let
    grep = getExe pkgs.gnugrep;
  in
    writeShellScriptBin "custom-java-formatter" ''
      set -euo pipefail
      set -x

      spotless_task_name='spotlessApply'

      if ! command -v gradle >/dev/null 2>&1; then
        echo "gradle not available" >&2
        exit 0
      fi

      if ! gradle tasks --all | ${grep} -q "^$spotless_task_name"; then
        echo "spotlessApply task not available" >&2
        exit 0
      fi

      gradle $spotless_task_name
    '';

  # Format:
  # <language_name> = {
  #   server = {
  #     name = <lspconfig-name>;
  #     path = getExe pkgs.<package-name>;
  #   };
  #   formatter = {
  #     name = <conform-name>;
  #     path = getExe pkgs.<package-name>;
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
        path = getExe pkgs.pyright;
      };
      formatter = {
        name = "yapf";
        path = getExe pkgs.yapf;
      };
    };

    c = {
      server = {
        name = "ccls";
        path = getExe pkgs.ccls;
      };
    };

    rust = {
      server = {
        name = "rust_analyzer";
        path = getExe pkgs.rust-analyzer;
      };
      formatter = {
        name = "rustfmt";
        path = getExe pkgs.rustfmt;
      };
      linter = {
        name = "clippy";
        path = getExe pkgs.clippy;
      };
    };

    lua = {
      server = {
        name = "lua_ls";
        path = getExe pkgs.lua-language-server;
      };
      formatter = {
        name = "stylua";
        path = getExe pkgs.stylua;
      };
    };

    typst = {
      server = {
        name = "tinymist";
        path = getExe pkgs.tinymist;
      };
      formatter = {
        name = "typstyle";
        path = getExe pkgs.typstyle;
      };
    };

    bash = {
      server = {
        name = "bashls";
        path = getExe pkgs.bash-language-server;
      };
      formatter = {
        name = "shfmt";
        path = getExe pkgs.shfmt;
      };
    };

    html = {
      server = {
        name = "html";
        path = getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
      };
      formatter = {
        name = "htmlbeautifier";
        path = getExe pkgs.rubyPackages.htmlbeautifier;
      };
    };

    css = {
      server = {
        name = "cssls";
        path = getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
      };
      formatter = {
        name = "stylelint";
        path = getExe pkgs.stylelint;
      };
    };

    json = {
      server = {
        name = "jsonls";
        path = getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
      };
      formatter = {
        name = "fixjson";
        path = getExe pkgs.fixjson;
      };
    };

    javascript = {
      server = {
        name = "eslint";
        path = getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
      };
      # TODO: formatter
    };

    kotlin = {
      # server = {
      #   name = "kotlin_language_server";
      #   path = getExe' pkgs.kotlin-language-server "kotlin-language-server";
      # };
      # formatter = {
      #   name = "ktfmt";
      #   path = getExe pkgs.ktfmt;
      # };
    };

    java = {
      server = {
        name = "jdtls";
        path = getExe pkgs.jdt-language-server;
      };
      formatter = {
        name = "custom-java-formatter";
        path = getExe customJavaFormatter;
      };
    };

    nix = {
      server = {
        name = "nixd";
        path = getExe pkgs.nixd;
      };
      formatter = {
        name = "alejandra";
        path = getExe pkgs.alejandra;
      };
    };

    dot = {
      server = {
        name = "dotls";
        path = getExe pkgs.dot-language-server;
      };
    };
  };

  toLua = v:
    if v == null
    then "nil"
    else if builtins.isString v
    then "'" + escape ["'" "\\"] v + "'"
    else if builtins.isList v
    then "{" + concatMapStringsSep "," toLua v + "}"
    else if builtins.isAttrs v
    then "{" + concatMapAttrsStringSep "," (name: value: name + "=" + toLua value) v + "}"
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
        CodeiumPath = '${getExe' codeium-lsp "codeium-lsp"}'

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
    })
    // {
      ".stylua.toml".source = (pkgs.formats.toml {}).generate ".stylua.toml" {
        column_width = 80;
        indent_type = "Spaces";
        quote_style = "AutoPreferSingle";
        call_parentheses = "None";
      };
    };
}
