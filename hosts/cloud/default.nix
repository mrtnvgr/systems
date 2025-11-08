{ ... }: {
  modules.generic = {
    sshd = {
      enable = true;
      keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkZjolhKpAeBEd9BHXbg/AVPjj7EYJv07nbtoyWRZJq4nYpWA7GX21fgH4g1v32ZjzqUtVXjBXZg6kYap1P2AxePQCQBYPksUVoS9lVVPSspyhx9Tk/9otyQh7Dye5jgfSRAo54Q1sRsEptN9351ti8smKt0u2eOCcGVStKSK3ZjB47issc4i2nOdInvhdA7ZZJvMAxepS+a3KVc2edkjBoSyuJ88IZaNlZcL5iE4UVeZ9C+QP0B6oBYQxIQZXq9ywCvVgZ8O0sU6aJxDLjuB3/7xAPpxHOW3hNYyoAgor0bpCiGd4nHX1wlJv//uW+yTWIyX+5Qimj/td4iORz/VHK7VVx81AJDapJqTPwOsXeg/x228/jXZy9I1b+ASH3qj6F4yo/e/rBXWLuxcdW4e+LYNzWAOzzztPyV78omeNmE2MgPwsvddmQgO5J45KNZjKejqCwUeXFjZGg98aFLq0Qnx6JM3hOyNFZWrWvbMchNqCO0YiQFbc4aY3ecfQfxU= u0_a368@localhost" ];
    };
  };

  modules.server = {
    enable = true;
    web.master = "martynovegorOF@yandex.ru";

    web = {
      enable = true;
      domain = "unixis.fun";

      eggs.enable = true;

      redirects = {
        "/github" = "https://github.com/mrtnvgr";
      };
    };

    misc = {
      torrserver.enable = true;
    };

    telegram.api = {
      enable = false;
      api_id = import ./secrets/tg_api_id;
      api_hash = import ./secrets/tg_api_hash;
    };

    telegram.yt = {
      enable = false;
      token = import ./secrets/tg_yt_token;
      adminId = 793346819;
    };
  };

  system.stateVersion = "24.05";
}
