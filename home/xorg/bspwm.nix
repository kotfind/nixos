{config, ...}: {
  xsession.windowManager.bspwm = (with config.cfgLib; enableFor users.kotfind) {
    enable = true;

    monitors.any =
      builtins.genList
      (n: builtins.toString (n + 1))
      9;

    settings = {
      border_width = 2;
      window_gap = 10;

      top_padding = 15;
      top_monocle_padding = 10;

      split_ratio = 0.5;

      gapless_monocle = true;
      single_monocle = true;

      focus_follows_pointer = true;
    };
  };
}
