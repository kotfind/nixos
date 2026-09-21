{config, ...}: let
  inherit (config.hostlib) hosts trueFor;
in {
  services.open-webui = {
    enable = trueFor hosts.pc;
    port = 1414;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
}
