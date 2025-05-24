{
  inputs,
  system,
  ...
}: let
  inherit (inputs) nixCats;

  masterPkgName = "nixCats";

  categoryDefinitions = {pkgs, ...}: let
  in {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        xclip
      ];
    };

    startupPlugins = with pkgs.vimPlugins; {
      general = [
        lze

        cyberdream-nvim
        lualine-nvim
        smear-cursor-nvim
        neoscroll-nvim
        nvim-notify

        comment-nvim
        nvim-ts-context-commentstring

        nvim-ts-autotag
        autoclose-nvim
        nvim-surround
      ];
    };
  };

  packageDefinitions.${masterPkgName} = {...}: {
    settings = {
      aliases = ["nvim" "vim"];

      hosts.python3.enable = false;
      hosts.node.enable = false;
    };

    categories = {
      general = true;
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
