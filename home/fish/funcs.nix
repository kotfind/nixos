{
  tempcd =
    /*
    fish
    */
    ''
      set dir (mktemp -d /tmp/tempcd.XXXXXXXXXX)
      echo $dir
      cd $dir
    '';

  start =
    /*
    fish
    */
    ''
      $argv[1..-1] &> /dev/null & disown
    '';
}
