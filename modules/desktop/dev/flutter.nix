{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  android = pkgs.android-studio-full;

  cfg = config.modules.desktop.dev.flutter;
in
{
  options.modules.desktop.dev.flutter.enable = mkEnableOption "flutter";

  config = mkIf cfg.enable {
    environment.variables.ANDROID_SDK_ROOT = "${android.sdk}/libexec/android-sdk";
    environment.systemPackages = [ pkgs.flutter android pkgs.openjdk ];
    nixpkgs.config.android_sdk.accept_license = true;
  };
}
