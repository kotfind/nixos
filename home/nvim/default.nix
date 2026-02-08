{
  inputs,
  system,
  pkgs,
  ...
}: let
  inherit (inputs) nixCats;

  toToml = (pkgs.formats.toml {}).generate;

  masterPkgName = "nixCats";

  spellPath = ".local/share/nvim/site/spell";

  categoryDefinitions = {pkgs, ...}: {
    lspsAndRuntimeDeps = with pkgs; {
      general = [
        xclip
        fd
        ripgrep
        glib # for gio for nvim-tree.lua
      ];
    };

    startupPlugins = with pkgs.vimPlugins; {
      general = [
        lze
      ];

      looks = [
        cyberdream-nvim
        lualine-nvim
        smear-cursor-nvim
        neoscroll-nvim
        nvim-web-devicons
        vim-signify
        noice-nvim
      ];

      manipulation = [
        comment-nvim
        nvim-ts-context-commentstring

        nvim-ts-autotag
        autoclose-nvim
        nvim-surround
      ];

      navigation = [
        telescope-nvim
        telescope-undo-nvim
        telescope-ui-select-nvim
        nvim-tree-lua
      ];

      treesitter = [
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        treewalker-nvim
      ];

      lsp = [
        nvim-lspconfig
        lsp_lines-nvim
      ];

      complete = [
        blink-cmp
        luasnip
      ];

      format = [
        conform-nvim
      ];
    };
  };

  packageDefinitions.${masterPkgName} = {pkgs, ...}: let
    inherit (pkgs.lib) getExe getExe';
  in {
    settings = {
      aliases = ["nvim" "vim"];

      hosts.python3.enable = false;
      hosts.node.enable = false;
    };

    categories = {
      general = true;
      looks = true;
      manipulation = true;
      navigation = true;
      treesitter = true;
      lsp = true;
      complete = true;
      format = true;
    };

    # specifying lsps and foramtters here, not to alter the $PATH
    extra = {
      lsps = {
        jdtls.rel = "jdtls";
        rust_analyzer.rel = "rust-analyzer";

        lua_ls = {
          rel = "lua-language-server";
          abs = getExe pkgs.lua-language-server;
        };

        tinymist = {
          rel = "tinymist";
          abs = getExe pkgs.tinymist;
        };

        nixd = {
          rel = "nixd";
          abs = getExe pkgs.nixd;
        };

        pyright = rec {
          rel = "pyright-langserver";
          abs = getExe' pkgs.pyright rel;
        };

        bashls = {
          rel = "bash-language-server";
          abs = getExe pkgs.bash-language-server;
        };

        ccls = {
          rel = "ccls";
          abs = getExe pkgs.ccls;
        };

        dotls = {
          rel = "dot-language-server";
          abs = getExe pkgs.dot-language-server;
        };

        kotlin_language_server.rel = "kotlin-language-server";

        arduino_language_server.rel = "arduino-language-server";

        jinja_lsp = {
          rel = "jinja-lsp";
          abs = getExe pkgs.jinja-lsp;
        };

        elmls.rel = "elm-language-server";

        tombi = {
          rel = "tombi";
          abs = getExe pkgs.tombi;
        };

        idris2_lsp.rel = "idris2-lsp";

        tailwindcss.rel = "tailwindcss-language-server";
      };

      formatters = {
        stylua = {
          rel = "stylua";
          abs = getExe pkgs.stylua;
        };

        typstyle = {
          rel = "typstyle";
          abs = getExe pkgs.typstyle;
        };

        alejandra = {
          rel = "alejandra";
          abs = getExe pkgs.alejandra;
        };

        rustfmt.rel = "rustfmt";

        leptosfmt.rel = "leptosfmt";

        black = {
          rel = "black";
          abs = getExe pkgs.black;
        };

        djlint = {
          rel = "djlint";
          abs = getExe pkgs.djlint;
        };

        tombi = {
          rel = "tombi";
          abs = getExe pkgs.tombi;
        };
      };
    };
  };

  builder =
    nixCats.utils.baseBuilder
    ./.
    {
      inherit system;
      inherit (inputs) nixpkgs;
    }
    categoryDefinitions
    packageDefinitions;

  masterPkg = builder masterPkgName;
in {
  home.packages = [masterPkg];

  home.sessionVariables = {
    MANPAGER = "nvim +Man! -c ':set signcolumn=no'";
    EDITOR = "nvim";
  };

  home.file = {
    "${spellPath}/ru.utf-8.spl".source = inputs.nvim-spl-ru;
    "${spellPath}/ru.utf-8.sug".source = inputs.nvim-sug-ru;
    "${spellPath}/en.utf-8.spl".source = inputs.nvim-spl-en;
    "${spellPath}/en.utf-8.sug".source = inputs.nvim-sug-en;
  };

  home.file.".config/tombi/config.toml".source = toToml "tombi-config.toml" {
    format.rules = {
      indent-width = 4;
      trailing-comment-space-width = 1;
    };
  };
}
