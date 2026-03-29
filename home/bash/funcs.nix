{...}: {
  programs.bash.initExtra = ''
    function tmpcd() {
      local dir="$(mktemp -d /tmp/tempcd.XXXXXXXXXX)"
      echo $dir
      cd $dir
    }

    for i in $(seq 2 10); do
      dots="$(printf '%.0s.' $(seq 1 $i))"
      path="$(printf '%.0s../' $(seq 1 $(($i - 1))))"
      alias "$dots"="cd $path"
    done
  '';
}
