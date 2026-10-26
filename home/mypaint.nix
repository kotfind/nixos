{
  pkgs,
  config,
  ...
}: let
  inherit (config.hostlib) hosts mkFor;

  # fix unmaintained package
  mypaint = pkgs.mypaint.overrideAttrs (old: {
    patches =
      old.patches
      ++ [
        (pkgs.fetchpatch {
          url = "https://github.com/mypaint/mypaint/commit/8ebfaf6de916e9734d79a86dd598ed1c57dcc77d.patch";
          hash = "sha256-+VaH3nt3ueLiwejCp7tpb/CpabC72Oey9aOhUM8+YTM=";
        })
      ];
  });
in {
  home.packages = mkFor hosts.pc [mypaint];
}
