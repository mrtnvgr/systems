{ inputs, user, config, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = {
      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      # Allow home-manager to control itself
      programs.home-manager.enable = true;

      # Sync home-manager's stateVersion with global stateVersion
      home.stateVersion = config.system.stateVersion;
    };
  };
}
