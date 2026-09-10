{pkgs, ...}:

{
  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color";
    hwRender = true; 
    
    fonts = [
      {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
      }
    ];
    
    extraConfig = ''
      font-size=14
    '';
  };
}