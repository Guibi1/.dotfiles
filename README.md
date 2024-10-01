# Home manager and NixOS dotfiles

My all in one linux environment and desktop rice !

## Installation

You can either follow along (i'll assume you clone this to `~/nix-config`), or run this one-liner (you _can_ omit the https if you aren't copy-pasting):

```bash
bash <(curl -fsSL https://go.ly/nixos)
```

### NixOS

First make sure NixOS is running the `unstable` channel.

```bash
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

Then, link the configuration file to `/etc/nixos/` and rebuild.

```bash
sudo ln -sf ~/nix-config/nixos-config.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch --upgrade
```

With that done, its time to install Home Manager !

### Home Manager

Add the home manager channel (yeah i didn't use the flake idk) and install it.

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

Now, you can link the entire repo to `.config/home-manager`, as god intended.

```bash
ln -sf ~/nix-config ~/.config/home-manager
home-manager switch
```

### Git signing

This clearly has nothing to do here, but use these commands to import and see the key GPG that git can use to sign the commits.

```bash
gpg --import private.gpg
gpg -K --keyid-format=long
```
