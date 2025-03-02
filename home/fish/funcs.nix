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
}
