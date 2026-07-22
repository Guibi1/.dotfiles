# Home manager and NixOS dotfiles

My all in one linux environment and desktop rice!

## Installation

You can either follow along (i'll assume you clone this to `~/nix-config`), or run this one-liner (you _can_ omit the https if you aren't copy-pasting):

```bash
bash <(curl -fsSL https://guibi.dev/nix)
```

### NixOS

```bash
sudo nixos-rebuild switch --flake ~/nix-config#Artemis
sudo nixos-rebuild switch --flake ~/nix-config#Apollon
```

### Darwin (macOS)

```bash
darwin-rebuild switch --flake ~/nix-config#Hermes
```

### Home Manager (WSL / standalone)

```bash
home-manager switch --flake ~/nix-config#guibi
```

### Git signing

This clearly has nothing to do here, but use these commands to import and see the key GPG that git can use to sign the commits.

```bash
gpg --import private.gpg
gpg -K --keyid-format=long
```
