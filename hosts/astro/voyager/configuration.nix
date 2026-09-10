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

    # 2. Configure fontconfig to make it your system-wide default monospace font
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
      
      # 3. Force crisp rendering layouts
      hinting = {
        enable = true;
        style = "slight"; # Keeps the shapes accurate without making them blurry
      };
      antialias = true; # Smooths out jagged pixel edges
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
