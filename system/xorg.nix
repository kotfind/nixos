{config, ...}: {
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          greeter.enable = false;
        };
        session = [
          {
            manage = "desktop";
            name = "xsession";
            start = "exec $HOME/.session";
          }
        ];
      };
    };

    displayManager = {
      defaultSession = "xsession";
      autoLogin = {
        enable = true;
        user = config.hostlib.users.kotfind.name;
      };
    };
  };
}
