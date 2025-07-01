{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config) sops;
  inherit (config.cfgLib) enableFor hosts;
  inherit (lib) getExe;
  inherit (pkgs) writeShellApplication;

  names = {
    backends.local = "local";
    locations.prog = "prog";
  };

  cfg = {
    version = 2;

    backends = {
      ${names.backends.local} = {
        type = "local";
        path = "/hdd/backups/restic";
      };
    };

    locations = {
      ${names.locations.prog} = {
        from = "/home/kotfind/prog";
        to = names.backends.local;

        options = {
          backup = {
            "exclude-caches" = true;

            exclude = [
              "target"
              "build"
              "bin"
              ".gradle"
              "venv"
              ".direnv"
            ];
          };

          forget = {
            "keep-within" = "60d";
          };
        };
      };
    };
  };

  localBackendPasswordSecret = "kotfind@kotfindPC/restic/backends/local/password";
  localBackendPasswordEnvTemplate = "autorestic-local-restic-password";
in {
  home.packages =
    (enableFor hosts.pc.users.kotfind)
    (with pkgs; [
      restic
      autorestic
    ]);

  home.file.".config/autorestic/.autorestic.yml".source = (pkgs.formats.yaml {}).generate "autorestic.yml" cfg;

  sops = {
    secrets.${localBackendPasswordSecret} = {};
    templates.${localBackendPasswordEnvTemplate}.content = ''
      AUTORESTIC_LOCAL_RESTIC_PASSWORD=${sops.placeholder.${localBackendPasswordSecret}}
    '';
  };

  systemd.user = enableFor hosts.pc.users.kotfind {
    services."restic-${names.locations.prog}" = {
      Service = {
        Type = "oneshot";
        ExecStart = getExe (writeShellApplication {
          name = "restic-backup-${names.locations.prog}";

          runtimeInputs = with pkgs; [
            restic
            autorestic
          ];

          text = ''
            autorestic --ci check
            autorestic --ci backup -l ${names.locations.prog}
          '';
        });

        EnvironmentFile = sops.templates.${localBackendPasswordEnvTemplate}.path;
      };
      Install = {
        WantedBy = ["multi-user.target"];
      };
    };

    timers."restic-${names.locations.prog}" = {
      Unit = {
        Requires = "restic-${names.locations.prog}.service";
      };

      Timer = {
        Unit = "restic-${names.locations.prog}.service";

        OnCalendar = "*-*-* 16:00:00";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
