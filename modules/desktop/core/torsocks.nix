{ pkgs, lib, config, user, ... }: let
  proxy = pkgs.writers.writePython3 "get-tor-proxy" {} /* python */ ''
    from ipaddress import ip_network
    import concurrent.futures
    import subprocess
    import socket
    import sys
    import re


    def get_local_network() -> str:
        result = subprocess.run(["ip", "route"], capture_output=True, text=True)
        match = re.search(r"(\d+\.\d+\.\d+)\.\d+/\d+", result.stdout)
        return f"{match.group(1)}.0/24"


    def check(ip: str) -> bool:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(0.1)
            return sock.connect_ex((ip, 9050)) == 0


    def get_proxy() -> str:
        net = get_local_network()
        net = ip_network(net, strict=False)

        with concurrent.futures.ThreadPoolExecutor(max_workers=255) as e:
            future_to_ip = {e.submit(check, str(ip)): ip for ip in net.hosts()}

            for future in concurrent.futures.as_completed(future_to_ip):
                if future.result():
                    return str(future_to_ip[future])

        sys.exit(1)


    print(get_proxy())
  '';

  # If torsocks is on, proxy finder will fail, so we can use it to toggle torsocks.
  # Cursed, but works :)
  ts = "${pkgs.torsocks}/bin/torsocks";
  gimmetor = "proxy=$(${proxy}) && . ${ts} -a $proxy on || . ${ts} off";
in {
  config = lib.mkIf config.modules.desktop.enable {
    environment.systemPackages = [ pkgs.torsocks ];

    # Silence torsocks
    environment.variables."TORSOCKS_LOG_LEVEL" = 1;

    home-manager.users.${user} = {
      programs.bash.shellAliases.gimmetor = gimmetor;
    };
  };
}
