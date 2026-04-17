{pkgs, ...}: {
  home.file.".blerc".text = ''
    bleopt history_share=1
  '';
}
