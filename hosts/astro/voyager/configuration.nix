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
