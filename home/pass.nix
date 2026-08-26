{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.home) homeDirectory;
  inherit (config.hostlib) mkFor users;
  inherit (lib) getExe;
  inherit (config.lib.dag) entryAfter;

  storeDir = "${homeDirectory}/.password-store";
in {
  programs.password-store = mkFor users.kotfind {
    enable = true;
    # it's not the default for whatever reason
    settings.PASSWORD_STORE_DIR = storeDir;
  };

  programs.rofi.pass = mkFor users.kotfind {
    enable = true;
    extraConfig = ''
      default_do='typePass'
    '';
  };

  services.pass-secret-service = {
    enable = true;
    storePath = storeDir;
  };

  home.activation.downloadPassswordStore = let
    storeGitRepo = "git@github.com:kotfind/pass";
    gitBin = getExe pkgs.git;
  in
    mkFor users.kotfind (entryAfter ["writeBoundary"]
      ''
        if [ ! -d ${storeDir} ]; then
            # Note: checking for git fail is usefull for initial
            # installation, when keys are not installed yet
            PATH="${pkgs.openssh}/bin:$PATH" \
                ${gitBin} clone ${storeGitRepo} ${storeDir} \
                    || "WARN: failed to fetch password-store from git"
        fi
      '');
}
