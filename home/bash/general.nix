{lib, ...}: let
  inherit (lib) mkAfter;
in {
  # prevents delay after entering a wrong command
  programs.bash.initExtra = mkAfter ''
    unset command_not_found_handle
    unset command_not_found_handler
  '';
}
