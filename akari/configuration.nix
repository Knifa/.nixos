{ config, lib, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  services.xserver = {
    enable = true;

    displayManager.sddm.enable = true;
    
    libinput.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  # Apply QMK udev rules for keyboard flashing.
  users.groups.plugdev = { };
  services.udev.packages = [
    pkgs.qmk-udev-rules
  ];

  hardware.openrazer = {
    enable = true;
    mouseBatteryNotifier = false;
    users = [ "dan" ];
  };

  users.users.dan = {
    isNormalUser = true;
    description = "Dan";
    extraGroups = [ "networkmanager" "plugdev" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    audacity
    chromium
    input-leap
    krita
    ondsel
    razergenie
    steam
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Ozone-Wayland for Electron apps.
  };

  networking.firewall.enable = false;

  environment.etc."u2f_keys".text = builtins.readFile ./u2f_keys;
  security.pam.services.kde.u2fAuth = true;
  security.pam.services.sudo.u2fAuth = true;
  security.pam.u2f.authFile = "/etc/u2f_keys";
  security.pam.u2f.cue = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
