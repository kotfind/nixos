{config, ...}: {
  imports = [./cfgLib];

  cfgLib = {
    usersDef = {
      kotfind = {
        email = "kotfind@yandex.ru";
      };

      root = {
        homeDir = "/root";
      };
    };

    hostsDef = {
      pc = {
        users = with config.cfgLib.users; [
          kotfind
          root
        ];
        data = {
          hostname = "kotfindPC";
        };
      };
      laptop = {
        users = with config.cfgLib.users; [
          kotfind
          root
        ];
        data = {
          hostname = "kotfindLT";
        };
      };
    };

    host = import ./current-host.nix config.cfgLib.hosts;
  };
}
