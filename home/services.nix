{ pkgs, cfg, ... }:
let
    composeService =
        {
            description,
            composeFile
        }: {
            Install = {
                WantedBy = [ "multi-user.target" ];
            };

            Service = let 
                    compose = "${pkgs.podman-compose}/bin/podman-compose";
                    cmd = "${compose} -f ${composeFile}";
                in {
                    Environment = [ "PATH=${pkgs.podman}/bin" ];

                    ExecStart = "${cmd} up -d";
                    ExecStop = "${cmd} down";

                    Type = "oneshot";
                    RemainAfterExit = true;
                };

            Unit = {
                Description = description;
                After = [ "network.target" ];
            };
        };
in
if cfg.fullname == "kotfind@kotfindPC" then {
    systemd.user.services = {
        navidrome = composeService {
            description = "Navidrome Music Service";
            composeFile = "/hdd/data/music/navidrome/docker-compose.yml";
        };
    };
} else {}
