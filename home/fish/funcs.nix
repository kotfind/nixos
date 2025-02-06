{
    tempcd = /* fish */ ''
        set dir (mktemp -d)
        echo $dir
        cd $dir
    '';
}
