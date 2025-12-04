{pkgs, ...}: {
  # TODO?: move to projects' own configurations?
  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "${pkgs.clang}/bin/clang"
    rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]
  '';
}
