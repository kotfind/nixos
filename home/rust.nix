{ pkgs, ... }:
{
    home.file.".cargo/config.toml".text = ''
        [target.x86_64-unknown-linux-gnu]
        linker = "${pkgs.clang}/bin/clang"
        rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]
    '';

    # TODO ?: move ra-multiplex config to nvim config?
    home.file.".config/ra-multiplex/config.toml".text = ''
        instance_timeout = 300
    '';

    systemd.user.services.ra-multiplex = {
        Unit = {
            After = [ "default.target" ];
        };

        Service = {
            Type = "simple";
            ExecStart = "${pkgs.ra-multiplex}/bin/ra-multiplex server";
        };

        Install = {
            WantedBy = [ "default.target" ];
        };
    };
}
