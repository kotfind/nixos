{
  inputs,
  system,
  ...
}: let
  inherit (inputs) nixCats;

  masterPkgName = "nixCats";

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
        nvim-notify
        nvim-web-devicons
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
    };
  };

  packageDefinitions.${masterPkgName} = {pkgs, ...}: {
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
    };

    extra = {
        # specifying lsps here, not to alter the $PATH
        #
        # type:
        # {
        #     <lspconfigName> = {
        #         rel = <relativePath>;
        #         abs = <absolutePath>;
        #     };
        # }
        lsps = let
            inherit (pkgs.lib) getExe;
        in {
            lua_ls = {
                rel = "lua-language-server";
                abs = getExe pkgs.lua-language-server;
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

  # TODO: spell files
}
