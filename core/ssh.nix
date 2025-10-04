{ user, ... }: {
  # Avoid session freeze
  home-manager.users."${user}" = {
    programs.ssh.matchBlocks."*".serverAliveInterval = 100;
  };
  services.openssh.extraConfig = ''
    ClientAliveInterval 100
    TCPKeepAlive yes
    ClientAliveCountMax 10000
  '';
}
