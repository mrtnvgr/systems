{ lib, ... }: {
  imports = [
    ./reaper
    ./renoise
  ];

  options._internals.isAnyDawInstalled = lib.mkEnableOption "<internal>";
}
