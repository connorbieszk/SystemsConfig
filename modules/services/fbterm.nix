{ pkgs, lib, ... }:

let
  # Build Antmicro's modern fork cleanly from the ground up to prevent Autotools injection
  antmicro-fbterm = pkgs.stdenv.mkDerivation {
    pname = "fbterm-antmicro";
    version = "2026-update";

    src = pkgs.fetchFromGitHub {
      owner = "antmicro";
      repo = "fbterm";
      rev = "master";
      sha256 = "sha256-mBH7enFfyx2TXOKM68zj3Dd/uumrcNHY0AfJJXOEqRw=";
    };

    # Explicitly pull in only the modern build requirements needed for CMake
    nativeBuildInputs = [
      pkgs.cmake
      pkgs.pkg-config
    ];

    # Runtime dependencies matching original fbterm core needs
    buildInputs = [
      pkgs.freetype
      pkgs.fontconfig
      pkgs.gpm # Mouse support header
      pkgs.ncurses # Terminfo engine definitions
    ];

    meta = with lib; {
      description = "Antmicro modernized fork of the Framebuffer Terminal Emulator";
      homepage = "https://github.com/antmicro/fbterm";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
    };
  };
in
{
  # Disable kmscon entirely to avoid physical display driver handoff locks
  services.kmscon.enable = false;

  # Grant privileged execution rights so fbterm can initialize /dev/fb0 hardware
  security.wrappers.fbterm = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${antmicro-fbterm}/bin/fbterm";
  };

  environment = {
    systemPackages = [ antmicro-fbterm ];

    # Intercept hardware TTY console logins and load user configurations
    interactiveShellInit = ''
            if [[ "$(tty)" =~ /dev/tty[0-9]+ ]]; then
              export TERM=xterm-256color

              # Drop layout configuration details straight into the target dotfile
              if [ ! -f "$HOME/.fbtermrc" ]; then
                cat << 'EOF' > "$HOME/.fbtermrc"
      font-name=FiraCode Nerd Font
      font-size=24
      color-palette=vga
      input-method=
      EOF
              fi
              
              # Launch the secure system console wrapper layer
              exec /run/wrappers/bin/fbterm
            fi
    '';
  };
}
