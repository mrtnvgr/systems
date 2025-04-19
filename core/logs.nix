{ ... }: {
  services.journald.extraConfig = "SystemMaxUse = 256M";
}
