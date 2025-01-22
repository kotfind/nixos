{ pkgs, ... }:
{
    home.file.".cargo/config.toml".text = ''
        [target.x86_64-unknown-linux-gnu]
        linker = "${pkgs.clang}/bin/clang"
        rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]
    '';

    home.file.".config/ra-multiplex/config.toml".text = ''
        instance_timeout = 300
    '';
}
