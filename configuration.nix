{ config, pkgs, ... }:

with pkgs;

let
  v = (import ./vim.nix) pkgs;

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos-mycoolvm"; # Define your hostname.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    elfutils pax-utils patchelf binutils wget git ccache gcc7 chromium v tmux file
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  services.xserver.enable = true;
  #services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  users.users = {
    hex = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };
  
  system.stateVersion = "19.03"; # Did you read the comment?

}
