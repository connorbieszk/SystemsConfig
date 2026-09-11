{ pkgs, lib, ... }:

let
  antmicro-fbterm = pkgs.fbterm.overrideAttrs (oldAttrs: {
    version = "2026-update";
    src = pkgs.fetchFromGitHub {
      owner = "antmicro";
      repo = "fbterm";
      rev = "master";
      sha256 = lib.fakeSha256;
    };
  });
in
{
  security.wrappers.fbterm = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${antmicro-fbterm}/bin/fbterm";
  };

  environment = {
    systemPackages = [ antmicro-fbterm ];

    interactiveShellInit = ''
      if [[ "$(tty)" =~ /dev/tty[0-9]+ ]]; then
        # Map your custom configuration flags into the fbterm runtime environment
        export TERM=xterm-256color
        
        # Execute the privileged fbterm wrapper with your precise visual settings
        exec /run/wrappers/bin/fbterm \
          --font-name="FiraCode Nerd Font" \
          --font-size=24 \
          --color-palette=vga \
          --no-mouse
      fi
    '';
  };
}
