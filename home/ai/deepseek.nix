{...}: let
in {
  sops.secrets.deepseekKey = {
    sopsFile = ./deepseek.enc.key;
    format = "binary";
  };
}
