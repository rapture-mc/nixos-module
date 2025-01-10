{
  pkgs,
  config,
  lib,
  ...
}: let
  generateAgeKey = pkgs.writeShellScriptBin "generateAgeKey" ''
    mkdir -p ~/.config/sops/age
    if [ "$(id -u)" -ne 0 ]; then
      echo "Error: This command must be run with sudo... Exiting!"
      exit 1
    elif [ -f /home/$SUDO_USER/.config/sops/age/keys.txt ]; then
      echo "Age keyfile already exists... Skipping"
      exit 1
    else
      echo "Generating age private key from this hosts SSH ed25519 key and outputting to ~/.config/sops/age/keys.txt"
      sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > /home/$SUDO_USER/.config/sops/age/keys.txt
      echo -e "Done!\n"

      echo "Setting correct ownership permissions on newly created ssh key..."
      sudo chown $SUDO_USER:users /home/$SUDO_USER/.config/sops/age/keys.txt
      echo -e "Done!\n"

      echo "Age public key is: $(cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age)"
    fi
  '';

  makeRepoGroupWriteable = pkgs.writeShellScriptBin "makeRepoGroupWriteable" ''
    if [ -z "$1" ]; then
      echo "Error: You must pass a directory as a paramater to this command... Exiting!"
      exit 1
    elif [ "$(id -u)" -ne 0 ]; then
      echo "Error: This command must be run with sudo... Exiting!"
      exit 1
    else
      echo "Ensuring files within $1 inherit the group belonging to $1..."
      find $1 -type d -exec chmod g+s '{}' \;
      echo -e "Done!\n"

      echo "Recursively setting group read/write permissions on $1..."
      chmod -R g+rw $1
      echo -e "Done!\n"
    fi
  '';

  generateWin22Image = pkgs.writeShellScriptBin "generateWin22Image" ''
    echo -e "This script will clone the github repo proactivelabs/packer-windows and build the Windows 2022 image contained in the repo with Packer.\n"

    while true; do
      read -p "Continue? (y/n)" response
      case $response in
        [Yy]* )
          if [ ! -d packer-windows ]; then
            git clone https://github.com/proactivelabs/packer-windows.git
          fi

          if [ ! -d packer-windows/output-windows_2022 ]; then
            cd packer-windows

            echo -e "Initializing and building Windows 2022 image for QCOW2..."

            packer init win2022.pkr.hcl
            packer build win2022.pkr.hcl
          else
            echo "Packer output directory already exists... Skipping build creation"
          fi

          echo  "Done!"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
      esac
    done
  '';

  whonixVersion = "17.2.3.7";
  installWhonix = pkgs.writeShellScriptBin "installWhonix" ''
    echo -e "This script will check for the existence of Whonix and if not found download Whonix from the internet and import it into VirtualBox"

    while true; do
      read -p "Continue? (y/n)" response
      case $response in
        [Yy]* )
          if ! VBoxManage list vms | grep -q "Whonix" && [ -e /tmp/Whonix-Xfce-${whonixVersion}.ova ]; then
            echo "Whonix VMs don't exist, importing..."

            VBoxManage import /tmp/Whonix-Xfce-${whonixVersion}.ova --vsys 0 --eula accept --vsys 1 --eula accept

          elif ! VBoxManage list vms | grep -q "Whonix" && [ ! -e /tmp/Whonix-Xfce-${whonixVersion}.ova ]; then
            echo "Whonix VMs don't exist and Whonix OVA file doesn't exist, downloading OVA file..."

            wget https://download.whonix.org/ova/${whonixVersion}/Whonix-Xfce-${whonixVersion}.ova -O /tmp/Whonix-Xfce-${whonixVersion}.ova

            VBoxManage import /tmp/Whonix-Xfce-${whonixVersion}.ova --vsys 0 --eula accept --vsys 1 --eula accept

            echo -e "Import successful!\n Cleaning up OVA file from /tmp folder..."

            rm /tmp/Whonix-Xfce-${whonixVersion}.ova

          else
            echo "Whonix VMs already exist, skipping..."

            exit 1

          fi

          echo  "Done!"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
      esac
    done
  '';

  startWhonix = pkgs.writeShellScriptBin "startWhonix" ''
    VBoxManage startvm Whonix-Gateway-Xfce --type headless

    sleep 1

    VBoxManage startvm Whonix-Workstation-Xfce
  '';

  stopWhonix = pkgs.writeShellScriptBin "stopWhonix" ''
    VBoxManage controlvm Whonix-Workstation-Xfce poweroff

    VBoxManage controlvm Whonix-Gateway-Xfce poweroff
  '';

  firstTimeSetup = pkgs.writeShellScriptBin "firstTimeSetup" ''
    if [ $# -ne 1 ]; then
      echo "You must supply at least one argument (the hostname)"
      exit 1
    fi

    echo "Cloning git directory to /tmp/mgc-machines"
    git clone https://github.com/rapture-mc/mgc-machines /tmp/mgc-machines

    cd /tmp/mgc-machines

    git checkout dev

    echo "Running nh os switch..."
    nh os switch . -H $1
  '';
in {
  environment.systemPackages =
    lib.optionals config.megacorp.services.restic.sftp-server.enable [makeRepoGroupWriteable]
    ++ lib.optionals config.megacorp.virtualisation.hypervisor.enable [generateWin22Image]
    ++ lib.optionals config.megacorp.virtualisation.whonix.enable [
      installWhonix
      startWhonix
      stopWhonix
    ]
    ++ [
      generateAgeKey
      firstTimeSetup
    ];
}
