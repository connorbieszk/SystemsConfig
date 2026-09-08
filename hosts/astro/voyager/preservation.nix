{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections/"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];

      users.pblez = {
        directories = [
          ".ssh"
          ".config/mozilla"
          ".config/Code/User/workspaceStorage"
          ".config/Code/User/globalStorage"
          ".local/share"
          "Projects"
        ];
      
        files = [
      
        ];
      };
    };
  };
}
