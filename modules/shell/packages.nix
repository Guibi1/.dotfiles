{ ... }: {
  config.shell.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      htop
      jq
      socat
      xdg-utils
    ];
  };

  config.shell.home = { pkgs, ... }: {
    home.packages = with pkgs; [
      yubikey-manager
      mosh
      ripgrep
      fd
      hyperfine
      tokei

      # TypeScript
      bun
      nodejs_22

      # Rust
      rustup
      binaryen
      go # Go

      # Nix
      nixd
      nil

      # Python
      python3
      ruff
      uv

      # Java
      graalvmPackages.graalvm-ce
      jdt-language-server

      # Embedded
      espup
      espflash
      probe-rs-tools
    ];
  };
}
