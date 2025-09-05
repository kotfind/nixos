{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) enableFor hosts;

  kotfindOnPc = hosts.pc.users.kotfind;
in {
  home.packages = enableFor kotfindOnPc (with pkgs; [
    beets
  ]);

  home.sessionVariables = enableFor kotfindOnPc {
    BEETSDIR = "/hdd/data/music/beet";
  };
}
