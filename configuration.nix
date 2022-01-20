{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
    ./kexec.nix
    ./justdoit.nix
    ./autoreboot.nix
  ];

  kexec.autoReboot = true;

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
      networks = {
      };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=ttyS0,115200"          # allows certain forms of remote access, if the hardware is setup right
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];
  services.openssh.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpoVrLWaUL+/LpS2WOpu5u0u6h7zoCPrPeXxwoBr49WFZS3X4MFPZuyqXPMI2Wd+G6IkCsaB05U2U0JnjyRi1nBiiHghq04Am31hZwJjgi0DGdv2gG0aQNtz4iNACCAI86ObfUv0azIrCnR1Y1vMp3AQ+etu8tKLnwktM3FDymt8XNRIiTJPYgqvxhmofCl5m9FU1AoACD4MqP67vwbjDeU4bXYterKBCt9bYtRMkfOni5Jb2opubHagzl8bx4Jd3nB1HK8Eg+eLly6qcZFqnHSe8muOeGdIolgIQbMHnGa3vhihwIKDFlwMKeEUuiHrNlQJG+6bSq+cewhCVjLqMJM3Ar8Gol94WtKmVNCPq35rer36cCzOPCUOt56ERVZku6LGonOV6NMyY4aCvWZHQrbO95N5O41po2ognUWYgJbgO2sa5tXbX1J+Fzcz28NBSX1aseif3O6fN+lTJSiSV/uwE2kgrnDrTyDV3bzYak6C2nOdnfzl3ibU3pE715387Dbju+H2FWvcwnqTkeV1L/YSkjQnFfY9XXea41Usv87DIBvd3ltsjGBXucoPjbzqSkk+BcI9CP80kBDk2z2JeYIxho6z0hy0D9qHcM9BeyH9A6YGV0STqW2V1B7qMrZZRdG7apQuvnmzOOE0YPxmh2Tv+jGF72psbQKplgue+gRw== chessai1996@gmail.com"
  ];
  networking.hostName = "kexec";
}
