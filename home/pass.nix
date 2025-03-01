{
  config,
  lib,
  pkgs,
  ...
}: let
  storeDir = "${config.home.homeDirectory}/.password-store";
in {
  programs = {
    password-store = (with config.cfgLib; enableFor users.kotfind) {
      enable = true;
      settings = {
        # it's not the default for whatever reason
        PASSWORD_STORE_DIR = storeDir;
      };
    };

    rofi.pass = (with config.cfgLib; enableFor users.kotfind) {
      enable = true;
      extraConfig = ''
        default_do='typePass'
      '';
    };
  };

  home.activation.downloadPassswordStore = let
    storeGitRepoArg = lib.escapeShellArg "git@github.com:kotfind/pass";
    storeDirArg = lib.escapeShellArg storeDir;
    git = lib.getExe pkgs.git;
  in
    (with config.cfgLib; enableFor users.kotfind)
    (config.lib.dag.entryAfter ["writeBoundary"]
      /*
      bash
      */
      ''
        if [ ! -d ${storeDir} ]; then
            # Note: checking for git fail is usefull for initial
            # installation, when keys are not installed yet
            PATH="${pkgs.openssh}/bin:$PATH" \
                ${git} clone ${storeGitRepoArg} ${storeDirArg} \
                    || "WARN: failed to fetch password-store from git"
        fi
      '');
}
