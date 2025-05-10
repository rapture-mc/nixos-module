{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.hypervisor;

  generateWinImage = pkgs.writeShellScriptBin "generateWinImage" ''
    echo -e "This script will build a Windows image with packer based on your selection.\n"
    echo ""

    while true; do
      echo -e "Which Windows Image?\n--------------------\n1. Server 2022\n2. Server 2019\n3. Windows 11\n4. Windows 10\n"
      read -p "Your selection: " response_image
      case $response_image in
        1 )
          packer_file="win2022.pkr.hcl"
          name="Windows-Server-2022"
          break;;
        2 )
          packer_file="win2019.pkr.hcl"
          name="Windows-Server-2019"
          break;;
        3 )
          packer_file="win11_23h2.pkr.hcl"
          name="Windows-11"
          break;;
        4 )
          packer_file="win10_22h2.pkr.hcl"
          name="Windows-10"
          break;;
        * ) echo -e "Please enter either 1, 2, 3 or 4\n\n";;
      esac
    done

    while true; do
      echo ""
      echo -e "I'll now download the $name image from the internet and output the image to the packer-windows/output-$name directory (relative to where this command was run)\n"
      read -p "Continue? (y/n)" response_continue
      case $response_continue in
        [Yy]* )
          if [ ! -d packer-windows ]; then
            git clone --quiet https://github.com/rapture-mc/packer-windows.git
          fi

          if [ ! -d packer-windows/output-$name ]; then
            cd packer-windows

            echo -e "Initializing and building Windows 2022 image for QCOW2..."

            packer init $packer_file
            packer build $packer_file
          else
            echo "Packer output directory $name already exists... Skipping build creation"
          fi

          echo  "Done!"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
      esac
    done
  '';

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.virtualisation.hypervisor = {
    enable = mkEnableOption ''
      Enable Libvirt hypervisor.

      Also setup a static IP and bridge interface with megacorp.config.networking.static-ip option.
    '';

    logo = mkEnableOption "Whether to show hypervisor logo on shell startup";

    libvirt-users = mkOption {
      type = types.listOf types.str;
      default = ["${config.megacorp.config.users.admin-user}"];
      description = "A list of users who will have access to the libvirt API";
    };
  };

  config = mkIf cfg.enable {
    users.groups.libvirtd.members = cfg.libvirt-users;

    services.earlyoom.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };

    environment.sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    environment.systemPackages = with pkgs; [
      libxslt
      opentofu
      packer
      virt-manager
      generateWinImage
    ];
  };
}
