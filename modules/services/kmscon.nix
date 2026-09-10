{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color --no-mouse";

    config = {
      hwaccel = true;
      font-name = "FiraCode Nerd Font";
      font-size = 24;
      palette = "vga";
    };
  };
}
