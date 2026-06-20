{pkgs, lib, ...}: let
  inherit (lib) getExe;

  rofiBin = getExe pkgs.rofi;

  askpassBin = pkgs.writeShellScriptBin "claude-sudo-askpass" ''
    exec ${rofiBin} \
      -dmenu \
      -password \
      -l 0 \
      -p "[sudo] claude" \
      -theme-str 'listview { enabled: false; }'
  '';
in {
  programs.claude-code = {
    enable = true;

    rulesDir = ./rules;
    skills = ./skills;

    settings.env.SUDO_ASKPASS = getExe askpassBin;
  };
}
