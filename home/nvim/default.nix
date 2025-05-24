{
  inputs,
  system,
  ...
}: let
  inherit (inputs) nixCats;

  masterPkgName = "nixCats";

  categoryDefinitions = {pkgs, ...}: let
    plug = pkgs.vimPlugins;
  in {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        xclip
      ];
    };

    startupPlugins = {
      general = with plug; [
        cyberdream-nvim
        lze
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
  };

  # TODO: spell files
}
