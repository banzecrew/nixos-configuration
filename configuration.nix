{ config, pkgs, ... }:

with pkgs;

let

  v = (import ./vim.nix) pkgs;

  tmpPackages = [];

  isEnableGUI = true;
  isEnableSSHD = true;
  isEnableFW = false;
  isAllowUnfree = true;

  hostName = "old-machine";

in

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
      };
    };
  };

  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  time = {
    timeZone = "Europe/Moscow";
  };

  environment = {
    systemPackages = [
      elfutils pax-utils patchelf binutils wget 
      git ccache gcc7 chromium v tmux file
    ] ++ tmpPackages;
  };

  nixpkgs = {
    config = {
      allowUnfree = isAllowUnfree;
    };
  };

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
    hostName = hostName; 
  };
  
  users.users = {
    hex = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };
  
  nix = { 
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 180d";
    };
  };

  system = {
    stateVersion = "19.03"; 
  };
}




