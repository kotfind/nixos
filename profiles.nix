{
  hostlib = {
    hosts = {
      pc = {
        userNames = [
          "kotfind"
          "root"
        ];
        hostname = "kotfindPC";
      };

      laptop = {
        userNames = [
          "kotfind"
          "root"
        ];
        hostname = "kotfindLT";
      };
    };

    users = {
      kotfind = {
        email = "kotfind@yandex.ru";
      };

      root = {
        homeDir = "/root";
      };
    };
  };
}
