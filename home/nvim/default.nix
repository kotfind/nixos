{
  inputs,
  system,
  ...
}: let
  inherit (inputs) nixCats;

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
        # nvim-notify
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

      blink = [
        blink-cmp
      ];

      format = [
        conform-nvim
      ];
    };
  };

  packageDefinitions.${masterPkgName} = {pkgs, ...}: let
    inherit (pkgs.lib) getExe;
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
      blink = true;
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

        pyright = {
          rel = "pyright";
          abs = getExe pkgs.pyright;
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

        rustfmt = {
          rel = "rustfmt";
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
}
