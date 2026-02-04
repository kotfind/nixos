{
  pkgs,
  inputs,
  system,
  ...
}: let
  inherit (inputs.nix-dash-docsets.legacyPackages.${system}) mkNixDocsetFeed;

  docsPack = mkNixDocsetFeed {
    baseURL = "http://localhost:0";
    zealCompat = true;
  };
in {
  home.packages =
    (with pkgs; [zeal])
    ++ [docsPack];
}
