{ pkgs, lib, ... }:
{
  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;
  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    bitwarden
    discord
    firefox
    spotify
    telegram-desktop
    vlc

    git
    nixd
    nixpkgs-fmt
    vscode-fhs

    discover # for flatpak
  ];

  services.flatpak.enable = true;
}