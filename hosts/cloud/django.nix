{
  name,
  src,

  extraPackages ? [],
  pythonPackages ? [],

  port ? 1455,
}:
{ pkgs, config, ... }:
let
  # TODO: use this
  packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      django
      gunicorn

      # TODO: move
      django-tables2
      django-filter
      pandas
      openpyxl
      pymorphy3 num2words
    ] ++ pythonPackages ))
  ] ++ extraPackages;
in {
  users.groups.${name} = {};
  users.users.${name}= {
    group = name;
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d '/var/db/${name}' 0700 ${name} ${name}"
  ];

  systemd.services.${name} = {
    enable = true;

    path = packages;

    after = [ "network.target" ];
    wants = [ "network-online.target" ];

    environment = {
      SECRET_KEY = "asdyq87ey871yeuhqd871h817hd87e2tg87yeukldmkfnjhu";
      # DEBUG = "False";
      DEBUG = "True";
    };

    script = ''
      set -eu -o pipefail
      python manage.py makemigrations
      python manage.py migrate
      python manage.py import_excel # TODO: move from here

      python manage.py runserver 0.0.0.0:${toString port}

      # gunicorn \
      #   -b 0.0.0.0:${toString port} \
      #   --access-logfile \
      #   --workers 1 \
      #   quiz2.wsgi
    '';

    serviceConfig = {
      User = "user"; # TODO: change to name
      Group = "users"; # TODO: change to name
      Type = "simple";
      NonBlocking = true;
      WorkingDirectory = src;
      TimeoutSec = 30;
      Restart = "on-failure";
      RestartSec = "5s";
    };

    wantedBy = [ "multi-user.target" ];
  };

  services.nginx.virtualHosts."qz.${config.modules.server.web.domain}" = {
      locations = {
        # "/static" = {
        #   root = "${src}/static";
        # };

        "/" = {
          proxyPass = "http://localhost:${toString port}";
        };
      };

      enableACME = true;
      forceSSL = true;
    };
}
