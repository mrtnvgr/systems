{ pkgs, ... }: {
  modules.server = {
    enable = true;

    sshKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkZjolhKpAeBEd9BHXbg/AVPjj7EYJv07nbtoyWRZJq4nYpWA7GX21fgH4g1v32ZjzqUtVXjBXZg6kYap1P2AxePQCQBYPksUVoS9lVVPSspyhx9Tk/9otyQh7Dye5jgfSRAo54Q1sRsEptN9351ti8smKt0u2eOCcGVStKSK3ZjB47issc4i2nOdInvhdA7ZZJvMAxepS+a3KVc2edkjBoSyuJ88IZaNlZcL5iE4UVeZ9C+QP0B6oBYQxIQZXq9ywCvVgZ8O0sU6aJxDLjuB3/7xAPpxHOW3hNYyoAgor0bpCiGd4nHX1wlJv//uW+yTWIyX+5Qimj/td4iORz/VHK7VVx81AJDapJqTPwOsXeg/x228/jXZy9I1b+ASH3qj6F4yo/e/rBXWLuxcdW4e+LYNzWAOzzztPyV78omeNmE2MgPwsvddmQgO5J45KNZjKejqCwUeXFjZGg98aFLq0Qnx6JM3hOyNFZWrWvbMchNqCO0YiQFbc4aY3ecfQfxU= u0_a368@localhost"
    ];

    ntfyChannel = "mrtnvgr-cloud";

    web = {
      enable = true;
      domain = "unixis.fun";
      master = "root@unixis.fun";

      eggs.enable = true;
      cors.enable = true;
      cdn.enable = true;

      redirects = {
        # TODO: add "/" to the names as a prefix
        "/github" = "https://github.com/mrtnvgr";
      };
    };

    # - Follow the setup guide: https://nixos-mailserver.readthedocs.io/en/latest/setup-guide.html
    # - Open these ports in your router: 25, 143, 465, 587, 993
    email = {
      enable = true;
      accounts."root@unixis.fun".hashedPasswordFile = ./secrets/mailpass;
    };

    misc = {
      torrserver = {
        enable = true;
        expose = true;
        users = import ./secrets/tsusers.nix;
        webUsers = import ./secrets/tsweb.nix;
      };
    };
  };

  systemd.services.botb-battles = {
    enable = true;

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.python3.withPackages (ps: with ps; [ requests ])}/bin/python ${./botb_battles.py}";
    };
  };

  system.stateVersion = "24.05";

  imports = [
    (import ./django.nix {
      name = "quiz";
      src = "/home/user/quiz";
    })
  ];
}
