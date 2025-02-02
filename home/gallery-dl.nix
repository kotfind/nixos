{ cfg, pkgs, ... }:
if cfg.fullname == "kotfind@kotfindPC" then {
    programs = {
        gallery-dl = {
            enable = true;

            # TODO: auth
        };

        fish.shellAliases = {
            gdl = "gallery-dl";
        };
    };
} else {}
