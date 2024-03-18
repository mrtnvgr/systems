{ pkgs, user, ... }: {
  home-manager.users.${user}.programs.bash.initExtra = ''
    ZSTD_CLEVEL=19
    ZSTD_NBTHREADS=`nproc --all`
  '';

  environment.systemPackages = with pkgs; [
    zip
    p7zip
    unrar
    unzip
  ];
}
