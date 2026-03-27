{config, ...}: let
  inherit (config.cfgLib) hosts enableFor;
in {
  security.acme = enableFor hosts.pc {
    acceptTerms = true;

    defaults = {
      email = "kotfind@yandex.ru";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "dynu";
      dnsPropagationCheck = false;
      environmentFile = config.sops.secrets.acmeEnv.path;
    };

    certs."kotfind.mywire.org".domain = "kotfind.mywire.org";
    certs."_.kotfind.mywire.org".domain = "*.kotfind.mywire.org";
  };

  sops.secrets.acmeEnv = enableFor hosts.pc {
    sopsFile = ./acme.enc.env;
    format = "dotenv";
  };
}
