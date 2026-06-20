{pkgs, ...}: let
  mkJson = (pkgs.formats.json {}).generate;

  keys = {
    bindings = [
      {
        context = "Chat";
        bindings = {
          "alt+e" = "chat:externalEditor";
          "ctrl+g" = null;
        };
      }
    ];
  };
in {
  home.file.".claude/keybindings.json".source =
    mkJson "claude-keys" keys;
}
