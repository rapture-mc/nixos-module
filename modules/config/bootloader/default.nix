{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.config.bootloader;

  # fallout = pkgs.fetchFromGitHub {
  #   owner = "shvchk";
  #   repo = "fallout-grub-theme";
  #   rev = "e8433860b11abb08720d7c32f5b9a2a534011bca";
  #   sha256 = "sha256-mvb44mFVToZ11V09fTeEQRplabswQhqnkYHH/057wLE=";
  # };

  cybergrub = pkgs.fetchFromGitHub {
    owner = "adnksharp";
    repo = "CyberGRUB-2077";
    rev = "76b13c8e591958a104f6186efae3000da1032a35";
    sha256 = "sha256-Y5Jr+huIXnsSbN/HFhXQewFprX+FySTPdUa1KT0nMfM=";
  };

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.config.bootloader = {
    enable = mkEnableOption "Whether to bootloader";

    type = mkOption {
      type = types.str;
      default = "grub";
      description = "Either grub or extlinux (Extlinux for raspberry Pi's";
    };

    efi.enable = mkEnableOption "Whether to enable EFI support";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable =
          if cfg.type == "grub"
          then true
          else false; # Need to disable grub if extlinux is enabled
        efiSupport =
          if cfg.efi.enable
          then true
          else false;
        efiInstallAsRemovable =
          if cfg.efi.enable
          then true
          else false;
        devices = ["nodev"];
        theme = cybergrub;
      };

      generic-extlinux-compatible = mkIf (cfg.type == "extlinux") {
        enable = true;
      };
    };
  };
}
