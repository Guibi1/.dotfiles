# Home manager and NixOS dotfiles

## Installation

You can either follow along (i'll assume you clone this to `~/nix-config`), or run this one-liner (you _can_ omit the https if you aren't copy-pasting):

```bash
curl -L https://t.ly/gfjh5 | bash
```

### NixOS

First make sure NixOS is running the `unstable` channel.

```bash
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

Then, link the configuration file to `/etc/nixos/` and rebuild.

```bash
sudo ln -sf ~/nix-config/configuration.nix /etc/nixos/configuration.nix
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
