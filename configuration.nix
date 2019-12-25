{ config, pkgs, ... }:

with pkgs;

let
  v = (import ./vim.nix) pkgs;

  isEnableGUI = true;
  isEnableSSHD = true;
  isEnableFW = false;

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

  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [
    elfutils pax-utils patchelf binutils wget 
    git ccache gcc7 chromium v tmux file
  ];

  services = {
    openssh.enable = isEnableSSHD;
    
    xserver = {
      enable = isEnableGUI;
      displayManager = {
        sddm.enable = isEnableGUI;
      };
      desktopManager = {
        plasma5.enable = isEnableGUI;
      };      
    };
  };

  networking = { 
    firewall = { 
      enable = isEnableFW; 
    }; 
  };
  
  users.users = {
    hex = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };
  
  system.stateVersion = "19.03"; # Did you read the comment?

}
