{...}: {
  sops = {
    age = {
      # FIXME: ssh keys are still being imported
      sshKeyPaths = [];
      # FIXME: custom user
      keyFile = "/home/kotfind/.config/sops/age/keys.txt";
    };
  };
}
