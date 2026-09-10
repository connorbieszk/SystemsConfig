{pkgs, ...}:

{
  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color";
    
    config = {
          hwaccel = true; 
    font-name = "FiraCode Nerd Font";
    font-size=14;
    };
  };
}