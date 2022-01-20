{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
    ./kexec.nix
    ./justdoit.nix
  ];

  kexec.justdoit = {
    rootDevice = "/dev/nvme0n1";
    bootSize = 512;
    bootType = "zfs";
    swapSize = 4 * 1024;
    luksEncrypt = false;
    uefi = true;
    nvme = true;
  };

  networking = {
    wireless = {
      enable = true;
      # empty set means "use /etc/wpa_supplicant.conf"
      networks = { };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=ttyS0,115200"          # allows certain forms of remote access, if the hardware is setup right
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  networking.hostName = "kexec";
}
