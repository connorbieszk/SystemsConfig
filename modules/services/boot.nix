{
  boot.loader = {
        efi = {
            canTouchEfiVariables = true;
        };
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
        };
        initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
        kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
  };
    };
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };
}