{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "astrovoyager";

  networking.networkmanager.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    micro
    curl
    ptyxis
    nautilus
    nixd
    nixfmt
    wget
    vscode
    libnotify
  ];

  # --- GLOBAL FONT MANAGEMENT CONFIGURATION ---
  fonts = {
    # 1. Install the font files into the system profile
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };

      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;
    };
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Connor B.";
      user.email = "98125183+connorbieszk@users.noreply.github.com";
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.11";
}
