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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "astrovoyager";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-shell-extensions
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pblez = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    initialPassword = "12345";
  };

  programs.firefox.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    micro
    curl
    ptyxis
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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
  };

  nixpkgs.config.allowUnfree = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  systemd.services.comin-notifier = {
    description = "Notify user on Comin build status";
    wantedBy = [ "multi-user.target" ];
    after = [ "comin.service" ];

    script = ''
      # Get the ID of the user's desktop session
      USER_ID=$(id -u pblez)
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

      # Monitor the comin service log
      ${pkgs.systemd}/bin/journalctl -u comin.service -f -n 0 | while read -r line; do
        if echo "$line" | grep -q "Applying local configuration"; then
          ${pkgs.sudo}/bin/sudo -u pblez ${pkgs.libnotify}/bin/notify-send "NixOS Update" "Comin is starting a new system build..." -i system-software-update
        fi
        if echo "$line" | grep -q "Deployment successful"; then
          ${pkgs.sudo}/bin/sudo -u pblez ${pkgs.libnotify}/bin/notify-send "NixOS Update" "System successfully rebuilt and switched!" -i checkbox-checked-symbolic
        fi
        if echo "$line" | grep -q "Deployment failed"; then
          ${pkgs.sudo}/bin/sudo -u pblez ${pkgs.libnotify}/bin/notify-send "NixOS Update Error" "The build failed. Check logs with: journalctl -u comin" -i dialog-error
        fi
      done
    '';

    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
    };
  };
  system.stateVersion = "26.11";
}
