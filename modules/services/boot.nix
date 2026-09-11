{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };

    };
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.watermark_boost_factor" = 0;
    };
    initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];

  };
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };
}
