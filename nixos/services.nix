{
  pkgs,
  config,
  ...
}: {
  systemd.services = (with config.cfgLib; enableFor hosts.pc) {
    navidrome = {
      description = "Navidrome Music Service";

      enable = true;

      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      path = with pkgs; [
        podman
      ];

      serviceConfig = let
        composeFile = "/hdd/data/music/navidrome/docker-compose.yml";
        compose = "${pkgs.podman-compose}/bin/podman-compose";
        cmd = "${compose} -f ${composeFile}";
      in {
        Type = "oneshot";
        RemainAfterExit = true;

        User = "kotfind";

        ExecStart = "${cmd} up -d";
        ExecStop = "${cmd} down";
      };
    };
  };
}
