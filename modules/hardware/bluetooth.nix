{ lib, ... }: {
  options.hardware.bluetooth.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Bluetooth NixOS module";
  };

  options.hardware.bluetooth.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Bluetooth home-manager module";
  };

  config.hardware.bluetooth.nixos = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        DeviceID = "bluetooth:004C:0000:0000";
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    systemd.services = {
      bluetooth.serviceConfig = {
        ProtectKernelTunables = lib.mkDefault true;
        ProtectKernelModules = lib.mkDefault true;
        ProtectKernelLogs = lib.mkDefault true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        SystemCallFilter = [
          "~@obsolete"
          "~@cpu-emulation"
          "~@swap"
          "~@reboot"
          "~@mount"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };

  config.hardware.bluetooth.home =
    { pkgs, ... }:
    let
      magicPodsCore = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "magicpodscore";
        version = "2.0.10-mac-parity";

        src = pkgs.fetchFromGitHub {
          owner = "haileyok";
          repo = "MagicPodsCore";
          rev = "09a9b1f663375ec8d1c5123ad8e0f87fc73dd2bf";
          hash = "sha256-UqoFY4O37z3xOYoYZYQGCTLV7zToqYxLwvQk9y9yw0g=";
        };
        sdbusCpp = pkgs.fetchFromGitHub {
          owner = "Kistler-Group";
          repo = "sdbus-cpp";
          tag = "v1.6.0";
          hash = "sha256-h4eSVBm5VO5ol883dFKoilVGAcQVANNbFFVxKib2D48=";
        };
        nlohmannJson = pkgs.fetchFromGitHub {
          owner = "nlohmann";
          repo = "json";
          tag = "v3.11.3";
          hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
        };
        tomlplusplus = pkgs.fetchFromGitHub {
          owner = "marzer";
          repo = "tomlplusplus";
          tag = "v3.4.0";
          hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
        };
        uSockets = pkgs.fetchFromGitHub {
          owner = "uNetworking";
          repo = "uSockets";
          tag = "v0.8.7";
          hash = "sha256-vf3xI5GOqTEZx8iXf133nQvhUylIRzJ3jGuNUcQk9nY=";
        };
        uWebSockets = pkgs.fetchFromGitHub {
          owner = "uNetworking";
          repo = "uWebSockets";
          tag = "v20.58.0";
          hash = "sha256-XSyX6iP+wlUcmBMdfvNyf/uFCzQGmogIS5ehUnRdWs0=";
        };

        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          pkg-config
        ];
        buildInputs = with pkgs; [
          openssl
          libpulseaudio
          bluez
          zlib
          systemd
          ffmpeg_8
        ];
        cmakeFlags = [
          "-DCMAKE_BUILD_TYPE=Release"
          "-DBUILD_TESTS=OFF"
          "-DBUILD_CODE_GEN=OFF"
          "-DBUILD_EXAMPLES=OFF"
          "-DBUILD_DOC=OFF"
          "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
          "-DFETCHCONTENT_SOURCE_DIR_SDBUS-CPP=${finalAttrs.sdbusCpp}"
          "-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON=${finalAttrs.nlohmannJson}"
          "-DFETCHCONTENT_SOURCE_DIR_TOMLPLUSPLUS=${finalAttrs.tomlplusplus}"
          "-DFETCHCONTENT_SOURCE_DIR_USOCKETS_CONTENT=${finalAttrs.uSockets}"
          "-DFETCHCONTENT_SOURCE_DIR_UWEBSOCKETS_CONTENT=${finalAttrs.uWebSockets}"
        ];
        installPhase = ''
          runHook preInstall
          install -Dm755 magicpodscore $out/bin/magicpodscore
          runHook postInstall
        '';

        meta = {
          description = "MagicPods background service (fork: AirPods hi-res mic + handoff)";
          homepage = "https://github.com/steam3d/MagicPodsCore";
          mainProgram = "magicpodscore";
          license = pkgs.lib.licenses.gpl3Only;
          platforms = [ "x86_64-linux" ];
        };
      });
      magicPods = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "magicpods";
        version = "1.0.3-mac-parity";

        src = pkgs.fetchFromGitHub {
          owner = "haileyok";
          repo = "MagicPodsLinux";
          rev = "4763c74188a1be7360204afb684fc8898edfe08d";
          hash = "sha256-cmmJdk2S9NY9ed0P0NJPoE9wKorTZTNDUv+XxLpwC/E=";
        };

        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          qt6.wrapQtAppsHook
        ];
        buildInputs = with pkgs; [
          qt6.qtbase
          qt6.qtdeclarative
          qt6.qtwebsockets
          qt6.qtsvg
          qt6.qttools
        ];
        cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
        installPhase = ''
          runHook preInstall
          install -Dm755 magicpods $out/bin/magicpods
          install -Dm644 ${finalAttrs.src}/src/app/qml/assets/icons/mp-logo-color.svg \
            $out/share/icons/hicolor/scalable/apps/magicpods.svg
          mkdir -p $out/share/applications
          cp ${finalAttrs.desktopItem}/share/applications/*.desktop \
            $out/share/applications/
          runHook postInstall
        '';
        desktopItem = pkgs.makeDesktopItem {
          name = "app.magicpods";
          desktopName = "MagicPods";
          exec = "magicpods";
          icon = "magicpods";
          comment = "Control center for Bluetooth headphones (AirPods, Beats, Galaxy Buds)";
          categories = [ "Utility" ];
          startupWMClass = "MagicPods";
        };

        meta = {
          description = "AirPods, Beats & Galaxy Buds integration for Linux";
          homepage = "https://magicpods.app/linux/";
          mainProgram = "magicpods";
          license = pkgs.lib.licenses.gpl3Only;
          platforms = [ "x86_64-linux" ];
        };
      });
    in
    {
      services.mpris-proxy.enable = true;

      home.packages = [
        magicPodsCore
        magicPods
      ];
    };
}
