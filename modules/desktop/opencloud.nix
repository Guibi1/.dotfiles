{ ... }: {
  config.desktop.home =
    { pkgs, lib, ... }:
    let
      openvfs = pkgs.stdenv.mkDerivation (_: {
        pname = "openvfs";
        version = "0.1.0-unstable-2026-11-05";

        src = pkgs.fetchFromGitHub {
          owner = "opencloud-eu";
          repo = "openvfs";
          rev = "c20c0fe4925607cb835a2d98f29632e954c558dd";
          hash = "sha256-O/or88niQACm7oA9MGqHZe+cw9XTAzUKhfkBg3fGUz8=";
        };

        nativeBuildInputs = with pkgs; [
          cmake
          kdePackages.extra-cmake-modules
          qt6.qtbase
          fuse3
        ];

        buildInputs = with pkgs; [
          fuse3
          nlohmann_json
        ];

        __structuredAttrs = true;
        strictDeps = true;
        dontWrapQtApps = true;

        cmakeFlags = with pkgs; [
          (lib.cmakeFeature "ECM_DIR" "${kdePackages.extra-cmake-modules}/share/ECM/cmake")
          (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" false)
          (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${qt6.qtbase}")
        ];

        meta = {
          description = "Virtual Filesystem Layer for cloud storages for the free desktop (FUSE based files-on-demand)";
          homepage = "https://github.com/opencloud-eu/openvfs";
          license = lib.licenses.gpl3Only;
          platforms = lib.platforms.linux;
        };
      });
    in
    {
      home.packages = with pkgs; [
        (opencloud-desktop.overrideAttrs (attrs: {
          version = "4.0.0-unstable-2026-11-05";
          src = pkgs.fetchFromGitHub {
            owner = "opencloud-eu";
            repo = "desktop";
            rev = "14976391df36fe7174f4cdffeff022f6fedd7213";
            hash = "sha256-5wVxbQ5rpQbIjwAXVPbAkWn/PY+BxgPjvBFVilAtXPI=";
          };
          buildInputs = attrs.buildInputs ++ [ openvfs ];
          cmakeFlags = (attrs.cmakeFlags or [ ]) ++ [
            (lib.cmakeFeature "OpenVFS_DIR" "${lib.getLib openvfs}/lib/cmake/openvfs")
          ];
          doInstallCheck = false;
          nativeInstallCheckInputs = [ ];
        }))
        opencloud-desktop-shell-integration-resources
      ];
    };
}
