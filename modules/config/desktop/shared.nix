{pkgs, ...}: {
  config = {
    networking.networkmanager.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.nerd-fonts.terminess-ttf
      ];
    };

    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;
      pipwire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };
  };
}
