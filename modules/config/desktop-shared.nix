{pkgs, ...}: {
  config = {
    networking.networkmanager.enable = true;

    # fonts = {
    #   enableDefaultPackages = true;
    #   packages = with pkgs; [
    #     (nerdfonts.override {fonts = ["Terminus"];})
    #     noto-fonts-emoji
    #   ];
    # };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.Terminus
        noto-fonts-emoji
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
