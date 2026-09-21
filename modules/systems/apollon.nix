{
  inputs,
  config,
  selectModules,
  ...
}:
let
  selectedModules = selectModules [
    config.hardware.base
    config.shell
    config.server.ssh
    config.server.k3s
    config.server.sftp
    config.server.backups
  ];
in
{
  config.flake.nixosConfigurations.Apollon = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = selectedModules.nixos ++ [
      ../../hosts/apollon/hardware-configuration.nix
      {
        networking.hostName = "Apollon";

        networking.interfaces.eno1.ipv4.addresses = [
          {
            address = "192.168.18.222";
            prefixLength = 24;
          }
        ];
        networking.defaultGateway = "192.168.18.1";
        networking.nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];

        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs = {
          forceImportRoot = false;
          extraPools = [
            "SSD"
            "Data"
          ];
        };

        system.stateVersion = "23.11";
        home-manager.users.guibi = {
          imports = selectedModules.home;
          programs.git.signing.key = "1F1C47D520393678";
        };
      }
    ];
  };

  config.server.sftp.users = [
    {
      name = "azom";
      keys = [ ];
      chroot = "/mnt/Data/Backups/Azom";
    }
    {
      name = "niftic";
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwSbiovllDA0ej4uBugI/nqx1u5LS0KinWBlQusElJk"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeoE2GlAJrG9kuRuzsRMA9nTKgK1b6VNlJHSauzMcSj"
      ];
      chroot = "/mnt/Data/Backups/Niftic";
    }
  ];

  config.server.backups = {
    settings.paths = [
      "/mnt/Data/OpenCloud"
      "/mnt/Data/Backups/Minecraft"
      "/mnt/Data/Backups/OpenEBS"
    ];

    remotes = [
      {
        name = "azom";
        host = "10.200.0.1";
        port = 2022;
        user = "guibi";
        resticPath = "/restic";
        passwordFile = "/home/guibi/keys/azom_restic";
        identityFile = "/home/guibi/keys/azom_ed25519";
        wg = {
          address = "10.200.0.2/32";
          endpoint = "azom.dev:48318";
          privateKeyFile = "/home/guibi/keys/azom_wireguard";
          publicKey = "n0FZu8oaSSzRyuBX/4QCpOR4vWh/AYKS13xLLme8QFQ=";
        };
      }
      {
        name = "niftic";
        host = "192.168.0.206";
        port = 22;
        user = "guibi";
        resticPath = "/uploads/restic";
        passwordFile = "/home/guibi/keys/niftic_restic";
        identityFile = "/home/guibi/keys/niftic_ed25519";
        wg = {
          address = "10.10.0.2/32";
          endpoint = "niftic.hopto.org:51820";
          privateKeyFile = "/home/guibi/keys/niftic_wireguard";
          publicKey = "qCeDw5Cdyax6YQ5KpztIkanXv63z8l1rVddvW6b5oXA=";
        };
      }
    ];
  };
}
