{
  users.users.pblez = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "udev"
    ]; # Enable ‘sudo’ for the user.
    initialPassword = "12345";
  };
}
