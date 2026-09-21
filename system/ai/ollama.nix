{
  pkgs,
  config,
  ...
}: let
  inherit (config.hostlib) hosts trueFor;
in {
  services.ollama = {
    enable = trueFor hosts.pc;
    package = pkgs.ollama-cuda;
    loadModels = ["qwen3.5:9b"];
  };
}
