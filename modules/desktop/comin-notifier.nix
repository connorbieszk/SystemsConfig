{
  systemd.services.comin-notifier = {
    description = "Notify user on Comin build status";
    wantedBy = [ "multi-user.target" ];
    after = [ "comin.service" ];

    script = ''
      # Get the ID of the user's desktop session
      USER_ID=$(id -u pblez)
      export XDG_RUNTIME_DIR="/run/user/$USER_ID"
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
      notify_user() {
        ${pkgs.sudo}/bin/sudo -u pblez ${pkgs.coreutils}/bin/env \
          "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" \
          "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" \
          ${pkgs.libnotify}/bin/notify-send --app-name="Comin / NixOS Deploy" "$@" || true
      }

      # Monitor the comin service log
      ${pkgs.systemd}/bin/journalctl -u comin.service -f -n 0 | while read -r line; do
        if echo "$line" | grep -q "New commits have been fetched"; then
          notify_user "Comin Update" "New configuration commits fetched." -i folder-download
        fi
        if echo "$line" | grep -q "a generation is evaluating"; then
          notify_user "Comin Update" "Evaluating the new system configuration..." -i system-search
        fi
        if echo "$line" | grep -q "deployer: deploying generation"; then
          notify_user "NixOS Update" "Comin is starting a new system build..." -i system-software-update
        fi
        if echo "$line" | grep -q "deployment ended"; then
          notify_user "NixOS Update" "System successfully rebuilt and switched!" -i checkbox-checked-symbolic
        fi
        if echo "$line" | grep -q "Deployment failed"; then
          notify_user "NixOS Update Error" "The build failed. Check logs with: journalctl -u comin" -i dialog-error
        fi
      done
    '';

    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
    };
  };
}