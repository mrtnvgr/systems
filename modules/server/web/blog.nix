{ inputs, pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.web.blog;
  domain = config.modules.server.web.domain;

  blog = pkgs.stdenv.mkDerivation {
    name = "blog";

    src = inputs.blog;

    nativeBuildInputs = [ pkgs.zola ];

    buildPhase = "zola build";
    installPhase = "cp -r public $out";
  };
in {
  options.modules.server.web.blog.enable = mkEnableOption "blog";

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."${domain}" = {
      root = blog;

      enableACME = true;
      forceSSL = true;
    };
  };
}
