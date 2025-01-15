rec {
    # Define these
    hostname = (throw "cfg.hostname should be defined in cfg.nix");
    username = (throw "cfg.username should be defined in cfg.nix");
    email = (throw "cfg.username should be defined in cfg.nix");

    # Don't change these:
    fullname = "${username}@${hostname}";
}
