{pkgs, ...}: {
  config = {
    networking.networkmanager.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.nerd-fonts.Terminus
      ];
    };

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
